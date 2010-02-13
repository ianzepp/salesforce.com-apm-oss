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

public with sharing class Sprint_ManageTasks extends Common_AbstractExtension {
    public Sprint_ManageTasks(ApexPages.StandardController controller) {
        super(controller);
    }

    // Private vars
    private Id selectedStoryId = getPageParam('selectedStoryId');
    private List<SelectOption> selectedStoryOptions = null; 
    private List<SelectOption> sprintUserOptions = null;
    private List<Task__c> taskList = null; 
    private List<Story__c> storyList = null;
    private Map<Id, List<Task__c>> selectedStoryTaskMap = new Map<Id, List<Task__c>>(); 
    private Boolean taskListIsInlineEdit = null;

    // sprint
    public Sprint__c getSprint() {
        return (Sprint__c) getControllerRecord();
    }

    public Id getSprintId() {
        return getControllerId();
    } 

    // Cached properties
    public void unsetCachedProperties() {  
        unsetSelectedStoryOptions();
        unsetSelectedStoryTaskList();
        unsetTaskList();
        unsetTaskListIsInlineEdit();
    }

    // story list
    public List<Story__c> getStoryList() {
        if (storyList == null)
            storyList = new Sprint_ManageStories(getController()).getStoryList();
        return storyList;
    }

    public Integer getStoryListSize() {
        return getStoryList().size();
    }

    public Story__c getStory(Id storyId) {
        return new Map<Id, Story__c>(getStoryList()).get(storyId);
    }

    // Selected id
    public Id getSelectedStoryId() {
        return selectedStoryId;
    }
    
    public void setSelectedStoryId(Id selectedStoryId) {
        this.selectedStoryId = selectedStoryId;
    }
    
    // Selected story options
    public List<SelectOption> getSelectedStoryOptions() {
        if (selectedStoryOptions != null)
            return selectedStoryOptions;

        // Rebuild cache            
        selectedStoryOptions = new List<SelectOption>();
        selectedStoryOptions.add(new SelectOption('', '--None--'));

        try {            
            for(Story__c story : getStoryList())
                selectedStoryOptions.add(new SelectOption(story.Id, story.Name));
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }
        
        return selectedStoryOptions;
    }
    
    public Integer getSelectedStoryOptionsSize() {
        return getSelectedStoryOptions().size();
    }

    public void unsetSelectedStoryOptions() {
        selectedStoryOptions = null;
    }

    // Task list
    public List<Task__c> getTaskList() {
        if (taskList != null)
            return taskList;
        
        // rebuild cache
        try {
            taskList = new List<Task__c>([
                select Name
                     , ActualHours__c
                     , CompletedRatio__c
                     , Description__c
                     , EstimatedHours__c
                     , HoursSummary__c
                     , IsBlocked__c
                     , IsCompleted__c
                     , IsInlineEdit__c
                     , IsLate__c
                     , LastModifiedDate
                     , Position__c
                     , SprintUser__r.User__c
                     , SprintUser__c
                     , Sprint__r.Status__c // used by taskboard_task
                     , Sprint__r.IsGeneralBacklog__c // used by taskboard_task
                     , Status__c
                     , Story__c
                  from Task__c
                 where Sprint__c = :getSprintId()
              order by Position__c asc 
            ]);
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }
        
        if (taskList == null) // if the query tossed an exception
            taskList = new List<Task__c>();

        return taskList;
    }
    
    public Integer getTaskListSize() {
        return getTaskList().size();
    }
    
    public void unsetTaskList() {
        taskList = null;
    }
    
    // selected story task mapping
    public List<Task__c> getSelectedStoryTaskList() {
    	if (selectedStoryTaskMap.containsKey(getSelectedStoryId()))
    	    return selectedStoryTaskMap.get(getSelectedStoryId());
    	
    	List<Task__c> taskList = new List<Task__c>();
    	
    	for(Task__c task : getTaskList()) {
    	    if (task.Story__c == getSelectedStoryId())
    	        taskList.add(task);
    	}
    	
    	selectedStoryTaskMap.put(getSelectedStoryId(), taskList);
    	return taskList;
    }

    public Integer getSelectedStoryTaskListSize() {
    	return getSelectedStoryTaskList().size();
    }
    
    public void unsetSelectedStoryTaskList() {
    	selectedStoryTaskMap.clear();
    }
    
    // Fetch that one story
    public Task__c getTask(String taskId) {
        return new Map<Id, Task__c>(getTaskList()).get(taskId);
    }

    // Inline Edit
    public Boolean getTaskListIsInlineEdit() {
        if (taskListIsInlineEdit != null)
            return taskListIsInlineEdit;
        
        taskListIsInlineEdit = false;
        
        for(Task__c task : getSelectedStoryTaskList()) {
            if (taskListIsInlineEdit == true)
                break;
            if (task.IsInlineEdit__c == false)
                continue;

            taskListIsInlineEdit = true;
        }
        
        return taskListIsInlineEdit;
    }

    public void unsetTaskListIsInlineEdit() {
        taskListIsInlineEdit = null;
    }

    // sprint user options
    public List<SelectOption> getSprintUserOptions() {
        if (sprintUserOptions == null)
            sprintUserOptions = new Sprint_ManageUsers(getController()).getSprintUserOptions();
        return sprintUserOptions;
    }

    // Page References
    public PageReference insertTask() {
        system.assert(null != getSprint(), 'Sprint object is null');
        system.assert(null != getSelectedStoryId(), 'Selected Story ID is null');
        
        Task__c task = new Task__c(
            IsInlineEdit__c = true,
            Position__c = getTaskListSize() + 1,
            Sprint__c = getSprint().Id,
            Story__c = getSelectedStoryId()
        );
        
        if (getTaskListSize() == 0)
            getTaskList().add(task);
        else
            getTaskList().add(0, task);
            
        unsetSelectedStoryTaskList();
        unsetTaskListIsInlineEdit();
        return null;
    }

    public PageReference enableTaskListIsInlineEdit() {
        for(Task__c task : getTaskList())
            task.IsInlineEdit__c = true;
            
        unsetTaskListIsInlineEdit();
        return null;
    }

    public PageReference enableTaskIsInlineEdit() {
        if (getPageParam('selectedId') == null)
            addMessage('Required parameter "selectedId" is missing');
        else if (getTask(getPageParam('selectedId')) == null)
            addMessage('No matching story task for that "selectedId" parameter exists in the list of story tasks: ' + getTaskList());
        else
            getTask(getPageParam('selectedId')).IsInlineEdit__c = true;
            
        unsetTaskListIsInlineEdit();
        return null;
    }

    public PageReference cancelTaskListIsInlineEdit() {
        unsetSelectedStoryTaskList();
        unsetTaskListIsInlineEdit();
        unsetTaskList(); // this clears the inline edit flag, via a refetch
        return null;
    }

    public PageReference cancelTaskIsInlineEdit() {
        if (getPageParam('selectedId') == null)
            addMessage('Required parameter "selectedId" is missing');
        else if (getTask(getPageParam('selectedId')) == null)
            addMessage('No matching story task for that "selectedId" parameter exists in the list of story tasks: ' + getTaskList());
        else
            getTask(getPageParam('selectedId')).IsInlineEdit__c = false;

        unsetTaskListIsInlineEdit();
        return null;
    }

    public PageReference cancelInsertTask() {
        if (getTaskListSize() != 0)
            getTaskList().remove(0); // new stories tasks are always created at the front.

        unsetSelectedStoryTaskList();
        unsetTaskListIsInlineEdit();
        return null;
    }

    public PageReference deleteTask() {
        if (getPageParam('selectedId') == null)
            addMessage('Required parameter "selectedId" is missing');
        else if (getTask(getPageParam('selectedId')) == null)
            addMessage('No matching story task for that "selectedId" parameter exists in the list of story tasks: ' + getTaskList());
        else try {
            delete getTask(getPageParam('selectedId'));
            
            addChangesSavedMessage();
            unsetCachedProperties();
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }

        return null;
    }

    public PageReference saveTaskList() {
        if (getTaskListSize() == 0)
            return null;

        try {
        	system.debug('getTaskList() = ' + getTaskList());
            upsert getTaskList();

            addChangesSavedMessage();
            unsetCachedProperties();
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }
                
        return null;
    }

    public PageReference saveTaskListAndInsert() {
        saveTaskList();

        if (getMessageListSize(ApexPages.Severity.ERROR) == 0)
            return insertTask();

        return null;
    }

    public PageReference saveTaskListAndReturn() {
        saveTaskList();
        return new PageReference('/' + getSprintId());
    }

    public PageReference redirectManageStories() {
        PageReference pageReference = System.Page.Sprint_ManageStories;
        pageReference.getParameters().put('id', getSprintId());
        pageReference.setRedirect(true);
        return pageReference;
    }

    public PageReference updateSelectedStory() {
        unsetSelectedStoryTaskList();
        unsetTaskListIsInlineEdit();
        unsetTaskList();
        return null;
    }
}