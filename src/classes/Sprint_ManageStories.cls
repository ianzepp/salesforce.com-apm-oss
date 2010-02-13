/**
 * Agile Process Management (OSS)
 *
 * Copyright (C) 2009 - 2010, Ian Zepp <ian.zepp@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

public with sharing class Sprint_ManageStories extends Common_AbstractExtension {
    public Sprint_ManageStories(ApexPages.StandardController controller) {
        super(controller);
    }

    // Private vars
    private List<SelectOption> sprintUserOptions = null;
    private List<SelectOption> workstreamRoleOptions = null;
    private List<Story__c> storyList = null;
    private Boolean storyListIsInlineEdit = null;
    private Boolean includeBacklog = false;
    private Story__c removedStory = null;
    
    // Cached properties
    public void unsetCachedProperties() {
        unsetStoryList();
        unsetStoryListIsInlineEdit();
        unsetRemovedStory();
    }
    
    // sprint
    public Sprint__c getSprint() {
        return (Sprint__c) getControllerRecord();
    }

    public Id getSprintId() {
        return getControllerId();
    } 

    // Include backlog
    public void setIncludeBacklog(Boolean includeBacklog) {
        this.includeBacklog = includeBacklog;
    }
    
    public Boolean getIncludeBacklog() {
        return includeBacklog;
    }
    
    public void unsetIncludeBacklog() {
        includeBacklog = false;
    }

    // Story List
    public List<Story__c> getStoryList() {
        if (storyList != null)
            return storyList;
        if (getSprintId() == null)
            return new List<Story__c>();
        
        // Include backlog?
        String getIncludeBacklogParam = getSprintId();
        
        if (getIncludeBacklog()) try {
            getIncludeBacklogParam = [
                select Id
                  from Sprint__c
                 where Workstream__c = :getSprint().Workstream__c
                   and IsGeneralBacklog__c = true
                 limit 1
            ].Id;
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }
        
        // Build cache
        try {
            storyList = new List<Story__c>([
                select Name
                     , ApprovalStatus__c
                     , CompletedRatio__c
                     , Description__c
                     , HoursSummary__c
                     , IsBlocked__c
                     , IsInlineEdit__c
                     , IsLate__c
                     , Points__c
                     , Position__c
                     , SprintUser__r.User__c
                     , SprintUser__c
                     , Sprint__r.IsGeneralBacklog__c
                     , Sprint__c
                     , TaskStatus__c
                     , WorkstreamRole__r.Name
                     , WorkstreamRole__c
                  from Story__c
                 where Sprint__c = :getSprintId()
                    or Sprint__c = :getIncludeBacklogParam
              order by Sprint__r.IsGeneralBacklog__c, Position__c 
            ]);
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }            
        
        if (storyList == null) // might happen if an exception was thrown
            storyList = new List<Story__c>();
            
        return storyList;
    }
    
    public Integer getStoryListSize() {
        return getStoryList().size();
    }

    public void unsetStoryList() {
        storyList = null;
    }
    
    // Inline Edits?
    public Boolean getStoryListIsInlineEdit() {
        if (storyListIsInlineEdit != null)
            return storyListIsInlineEdit;
            
        storyListIsInlineEdit = false;
        
        for(Story__c story : getStoryList()) {
            if (storyListIsInlineEdit == true)
                break;
            if (story.IsInlineEdit__c == false)
                continue;

            storyListIsInlineEdit = true;
        }
        
        return storyListIsInlineEdit;
    }
    
    public void unsetStoryListIsInlineEdit() {
        storyListIsInlineEdit = null;
    }

    // Story (By Id)    
    public Story__c getStory(String storyId) {
        return new Map<Id, Story__c>(getStoryList()).get(storyId);
    }    

    // Confirm story removal
    public Story__c getRemovedStory() {
        return removedStory;
    }

    public void setRemovedStory(Story__c removedStory) {
        this.removedStory = removedStory;
    }

    public void unsetRemovedStory() {
        removedStory = null;
    }

    // workstream role options
    public List<SelectOption> getWorkstreamRoleOptions() {
        if (workstreamRoleOptions == null)
            workstreamRoleOptions = new Sprint_ManageUsers(getController()).getWorkstreamRoleOptions();
        return workstreamRoleOptions;
    }

    // sprint user options
    public List<SelectOption> getSprintUserOptions() {
        if (sprintUserOptions == null)
            sprintUserOptions = new Sprint_ManageUsers(getController()).getSprintUserOptions();
        return sprintUserOptions;
    }

    // Add and remove stories
    public PageReference assignStory() {
        if (getSprintId() == null)
            addMessage('Internal Error: Sprint ID is null.');
        else if (getPageParam('selectedId') == null)
            addMessage('Internal Error: required parameter "selectedId" is missing');
        else if (getStory(getPageParam('selectedId')) == null)
            addMessage('Internal Error: no matching story for that "selectedId" parameter exists in the list of stories: ' + getStoryList());
        else try {
            Story__c story = getStory(getPageParam('selectedId'));
            story.Sprint__c = getSprintId();
            upsert story;
            
            addChangesSavedMessage();
            unsetCachedProperties();
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }

        return null;
    }

    public PageReference insertStory() {
        if (getSprintId() == null)
            addMessage('Internal Error: Sprint ID is null.');
        else if (getSprint() == null)
            addMessage('Internal Error: Sprint is null.');
        else if (getSprint().Workstream__c == null)
            addMessage('Internal Error: Sprint.Workstream__c ID is null.');
        else try {
            Story__c story = new Story__c(
                IsInlineEdit__c = true,
                Position__c = getStoryListSize() + 1,
                Sprint__c = getSprintId(),
                Workstream__c = getSprint().Workstream__c
            );
            
            if (getStoryListSize() == 0)
                getStoryList().add(story);
            else
                getStoryList().add(0, story);

            unsetStoryListIsInlineEdit(); 
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }
                   
        return null;
    }

    
    public PageReference enableStoryListIsInlineEdit() {
        for(Story__c story : getStoryList()) {
            //
            // Only allow edits to stories in the general backlog, when the sprint being displayed
            // actually IS the general backlog. 
            //
            
            if (story.Sprint__r.IsGeneralBacklog__c == true && story.Sprint__c != getSprintId())
                continue;
            story.IsInlineEdit__c = true;
        }
        
        unsetStoryListIsInlineEdit();
        return null;
    }
    
    public PageReference enableStoryIsInlineEdit() {
        if (getPageParam('selectedId') == null)
            addMessage('Internal Error: required parameter "selectedId" is missing');
        else if (getStory(getPageParam('selectedId')) == null)
            addMessage('Internal Error: no matching story for that "selectedId" parameter exists in the list of stories: ' + getStoryList());
        else
            getStory(getPageParam('selectedId')).IsInlineEdit__c = true;
            
        unsetStoryListIsInlineEdit();
        return null;
    }

    public PageReference cancelStoryIsInlineEdit() {
        if (getPageParam('selectedId') == null)
            addMessage('Internal Error: required parameter "selectedId" is missing');
        else if (getStory(getPageParam('selectedId')) == null)
            addMessage('Internal Error: no matching story for that "selectedId" parameter exists in the list of stories: ' + getStoryList());
        else
            getStory(getPageParam('selectedId')).IsInlineEdit__c = false;
            
        unsetStoryListIsInlineEdit();
        return null;
    }

    public PageReference cancelInsertStory() {
        if (getStoryListSize() != 0)
            getStoryList().remove(0); // new stories are always created at the front.
            
        unsetStoryListIsInlineEdit();
        return null;
    }
    
    public PageReference cancelRemoveStory() {
        unsetRemovedStory();
        return null;
    }

    public PageReference cancel() {
        unsetCachedProperties();
        return null;
    }

    public PageReference confirmRemoveStory() {
        if (getRemovedStory() == null)
            addMessage('Internal Error: missing removedStory object.');
        else if (getRemovedStory().Sprint__c == null)
            addMessage('Internal Error: removedStory.Sprint__c is null.');
        else try {
            getRemovedStory().Sprint__c = null;
            upsert getRemovedStory();
            addChangesSavedMessage();
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }

        unsetCachedProperties();
        return null;
    }

    public PageReference deleteStory() {
        if (getPageParam('selectedId') == null)
            addMessage('Internal Error: required parameter "selectedId" is missing');
        else if (getStory(getPageParam('selectedId')) == null)
            addMessage('Internal Error: no matching story for that "selectedId" parameter exists in the list of stories: ' + getStoryList());
        else try {
            delete getStory(getPageParam('selectedId'));
            addChangesSavedMessage();
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        } 
        
        unsetCachedProperties();        
        return null;
    }

    public PageReference saveStoryList() {
        if (getStoryListSize() == 0)
            addMessage('Internal Error: storyList is empty; nothing to do.');
        else try {
            upsert getStoryList();
            addChangesSavedMessage();
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }
    
        unsetCachedProperties();
        return null;
    }

    public PageReference saveStoryListAndInsert() {
        if (getStoryListSize() != 0) try {
            upsert getStoryList();
            addChangesSavedMessage();
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        } finally {
            unsetCachedProperties();
        }

        if (getMessageListSize(ApexPages.Severity.ERROR) != 0)
            return null;
        return insertStory();
    }
    
    public PageReference saveStoryListAndReturn() {
        saveStoryList();
        return new PageReference('/' + getSprintId());
    }

    public PageReference removeStory() {
        if (getPageParam('selectedId') == null)
            addMessage('Internal Error: required parameter "selectedId" is missing');
        else if (getStory(getPageParam('selectedId')) == null)
            addMessage('Internal Error: no matching story for that "selectedId" parameter exists in the list of stories: ' + getStoryList());
        else
            setRemovedStory(getStory(getPageParam('selectedId')));
        return null;
    } 

    public PageReference redirectManageTasks() {
        PageReference pageReference = System.Page.Sprint_ManageTasks;
        pageReference.getParameters().put('id', getSprintId());
        pageReference.getParameters().put('selectedStoryId', getPageParam('selectedStoryId'));
        pageReference.setRedirect(true);
        return pageReference;
    }
    
    public PageReference updateIncludeBacklog() {
        unsetStoryList();
        unsetStoryListIsInlineEdit();
        return null;
    }
}