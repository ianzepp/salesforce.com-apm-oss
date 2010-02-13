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

public with sharing class Sprint_ManageCases extends Common_AbstractExtension {
    public Sprint_ManageCases(ApexPages.StandardController controller) {
        super(controller);
        
        // Setup the delegate controller
        workstreamDelegate = new Workstream_ManageCases(new ApexPages.StandardController([
            select Workstream__r.Id
              from Sprint__c
             where Id = :getSprintId()
        ].Workstream__r));
    }

    // Private vars
    private Workstream_ManageCases workstreamDelegate = null;
    private List<WorkstreamCase__c> workstreamCaseList = null;
    private List<SelectOption> sprintOptions = null;
    private List<SelectOption> storyOptions = null;
    private Boolean includeBacklog = false;
     
    // Reset cache
    public void unsetCachedProperties() { 
        unsetNewWorkstreamCase();
        unsetStoryOptions();
        unsetWorkstreamCaseList();
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
        return includeBacklog == null ? false : includeBacklog;
    }
    
    public void unsetIncludeBacklog() {
        includeBacklog = false;
    }

    // Workstream case
    public WorkstreamCase__c getNewWorkstreamCase() {
        return getWorkstreamDelegate().getNewWorkstreamCase();
    }

    public void unsetNewWorkstreamCase() {
        getWorkstreamDelegate().unsetNewWorkstreamCase();
    }

    // workstream delegate
    public Workstream_ManageCases getWorkstreamDelegate() {
        return workstreamDelegate;
    }

    // workstream case list
    public List<WorkstreamCase__c> getWorkstreamCaseList() {
        if (workstreamCaseList != null)
            return workstreamCaseList;
        if (getSprintId() == null)
            return new List<WorkstreamCase__c>();
        
        // Include backlog?
        Id generalBacklogId = null;
        
        if (getIncludeBacklog()) try {
            generalBacklogId = [
                select Id
                  from Sprint__c
                 where Workstream__c = :getSprint().Workstream__c
                   and IsGeneralBacklog__c = true
                 limit 1
            ].Id;
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }

        // Extract only those in this sprint (or in the general backlog if required)
        workstreamCaseList = new List<WorkstreamCase__c>();
        
        for (WorkstreamCase__c workstreamCase : getWorkstreamDelegate().getWorkstreamCaseList()) {
            system.debug(workstreamCase);
            
            if (workstreamCase.Sprint__c == getSprintId())
                workstreamCaseList.add(workstreamCase);
            if (getIncludeBacklog() && workstreamCase.Sprint__c == getWorkstreamDelegate().GetBacklogSprint().Id)
                workstreamCaseList.add(workstreamCase);
        }
        
        return workstreamCaseList;
    }

    public Integer getWorkstreamCaseListSize() {
        return getWorkstreamCaseList().size();
    }

    public WorkstreamCase__c getWorkstreamCase(Id workstreamCaseId) {
        return new Map<Id, WorkstreamCase__c>(getWorkstreamCaseList()).get(workstreamCaseId);
    }

    public Boolean hasWorkstreamCaseByCaseId(Id caseId) {
        for (WorkstreamCase__c workstreamCase : getWorkstreamCaseList()) {
            if (workstreamCase.Case__c == caseId)
                return true;
        }
        
        return false;
    }

    public void unsetWorkstreamCaseList() {
        workstreamCaseList = null;
        workstreamDelegate.unsetWorkstreamCaseList();
    }
    
    // sprint options - only used when assigning cases from a general backlog > manage cases page.
    public List<SelectOption> getSprintOptions() {
        if (sprintOptions != null)
            return sprintOptions;

        // Rebuild cache            
        sprintOptions = new List<SelectOption>();
        sprintOptions.add(new SelectOption('', '--None--'));

        try {            
            for(Sprint__c sprint : [
                select Name
                  from Sprint__c
                 where Workstream__c = :getSprint().Workstream__c
                   and Status__c in ('Not Yet Started', 'In Progress')
              order by Name asc 
            ]) sprintOptions.add(new SelectOption(sprint.Id, sprint.Name));
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }
        
        return sprintOptions;
    }
    
    public Integer getSprintOptionsSize() {
        return getSprintOptions().size();
    }

    public void unsetSprintOptions() {
        sprintOptions = null;
    }
    
    // story options
    public List<SelectOption> getStoryOptions() {
        if (storyOptions != null)
            return storyOptions;

        // Rebuild cache            
        storyOptions = new List<SelectOption>();
        storyOptions.add(new SelectOption('', '--None--'));

        try {            
            for(Story__c story : [
                select Name
                  from Story__c
                 where Sprint__c = :getSprintId()
              order by Name asc 
            ]) storyOptions.add(new SelectOption(story.Id, story.Name));
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }
        
        return storyOptions;
    }
    
    public Integer getStoryOptionsSize() {
        return getStoryOptions().size();
    }

    public void unsetStoryOptions() {
        storyOptions = null;
    }
    
    // Page actions
    public PageReference assignWorkstreamCase() {
        if (getSprintId() == null)
            addMessage('Internal Error: Sprint ID is null.');
        else if (getPageParam('selectedId') == null)
            addMessage('Internal Error: required parameter "selectedId" is missing');
        else if (getWorkstreamCase(getPageParam('selectedId')) == null)
            addMessage('Internal Error: no matching workstream case for that "selectedId" parameter exists in the list of workstream cases: ' + getWorkstreamCaseList());
        else try {
            WorkstreamCase__c workstreamCase = getWorkstreamCase(getPageParam('selectedId'));
            workstreamCase.Sprint__c = getSprintId();
            upsert workstreamCase;

            addChangesSavedMessage();
            unsetCachedProperties();
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }

        return null;
    }

    public PageReference assignWorkstreamCaseAndConvert() {
        assignWorkstreamCase();
        
        if (getMessageListSize(ApexPages.Severity.ERROR) == 0)
            return convertWorkstreamCase();

        return null;
    }
    
    public PageReference insertWorkstreamCase() {
        if (getSprintId() == null)
            addMessage('Sprint ID is null');
        else if (getSprint() == null)
            addMessage('Sprint is null');
        else if (getSprint().Workstream__c == null)
            addMessage('Sprint.Workstream__c ID is null');
        else if (getNewWorkstreamCase() == null)
            addMessage('New WorkstreamCase ID is null');  
        else if (getNewWorkstreamCase().Case__c == null)
            addMessage('New WorkstreamCase.Case__c ID is null');
        else if (hasWorkstreamCaseByCaseId(getNewWorkstreamCase().Case__c))
            addMessage('Case is already associated with this Sprint.');
        else try {
            WorkstreamCase__c workstreamCase = getNewWorkstreamCase();
            workstreamCase.Sprint__c = getSprintId();
            workstreamCase.Workstream__c = getSprint().Workstream__c;
            upsert workstreamCase;
            
            addChangesSavedMessage();
            unsetCachedProperties();        
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }

        return null;
    }

    public PageReference saveWorkstreamCaseList() {
        if (getWorkstreamCaseListSize() == 0)
            return null;
        
        try {
            List<Case> caseList = new List<Case>();

            for(WorkstreamCase__c workstreamCase : getWorkstreamCaseList())
                caseList.add(workstreamCase.Case__r);

            upsert getWorkstreamCaseList();
            upsert caseList;

            addChangesSavedMessage();
            unsetCachedProperties();        
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        } 
        
        return null;
    }

    public PageReference saveWorkstreamCaseListAndReturn() {
        saveWorkstreamCaseList();
        
        if (getMessageListSize(ApexPages.Severity.ERROR) == 0)
            return new PageReference('/' + getSprintId());

        return null;
    }

    public PageReference deleteWorkstreamCase() {
        if (getPageParam('selectedId') == null)
            addMessage('Required parameter "selectedId" is missing');
        else if (getWorkstreamCase(getPageParam('selectedId')) == null)
            addMessage('No matching workstream case for that "selectedId" parameter exists in the list of workstream cases: ' + getWorkstreamCaseList());
        else try {
            WorkstreamCase__c workstreamCase = getWorkstreamCase(getPageParam('selectedId'));
            workstreamCase.Sprint__c = null;
            workstreamCase.Story__c = null;
            upsert workstreamCase;

            addChangesSavedMessage();
            unsetCachedProperties();
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }
        
        return null;
    }

    public PageReference convertWorkstreamCase() {
        if (getPageParam('selectedId') == null)
            addMessage('Required parameter "selectedId" is missing');
        else if (getWorkstreamCase(getPageParam('selectedId')) == null)
            addMessage('No matching workstream case for that "selectedId" parameter exists in the list of workstream cases: ' + getWorkstreamCaseList());
        else try {
            // cache case
            WorkstreamCase__c workstreamCase = getWorkstreamCase(getPageParam('selectedId'));

            // add story
            Story__c story = new Story__c();
            story.Sprint__c = getSprintId();
            story.Workstream__c = getSprint().Workstream__c;
            story.Name = 'Case ' + workstreamCase.Case__r.CaseNumber + ': ' + workstreamCase.Case__r.Subject;
            
            // resize name?
            if (story.Name.length() > 75)
                story.Name = story.Name.substring(0, 75) + '...';
            
            insert story;
            
            // update case
            workstreamCase.Story__c = story.Id;
            upsert workstreamCase;

            // notify            
            addChangesSavedMessage();
            unsetCachedProperties();
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }
        
        return null;
    }

    public PageReference updateIncludeBacklog() {
        unsetWorkstreamCaseList();
        return null;
    }

    public PageReference redirectManageStories() {
        PageReference pageReference = System.Page.Sprint_ManageStories;
        pageReference.getParameters().put('id', getSprintId());
        pageReference.setRedirect(true);
        return pageReference;
    }

}