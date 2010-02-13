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

public with sharing class Sprint_ManageUsers extends Common_AbstractExtension {
    public Sprint_ManageUsers(ApexPages.StandardController controller) {
        super(controller);
    } 

    // private vars
    private List<SelectOption> sprintUserOptions = null;
    private List<SelectOption> workstreamRoleOptions = null;
    private List<SprintUser__c> sprintUserList = null;
    private SprintUser__c newSprintUser = new SprintUser__c();    
    
    // reset cache
    public void unsetCachedProperties() { 
        unsetNewSprintUser();
        unsetSprintUserList();
        unsetSprintUserOptions();
    }

    // sprint
    public Sprint__c getSprint() {
        return (Sprint__c) getControllerRecord();
    }

    public Id getSprintId() {
        return getControllerId();
    } 

    // new sprint user
    public SprintUser__c getNewSprintUser() {
        return newSprintUser;
    }
    
    public void setNewSprintUser(SprintUser__c newSprintUser) {
        this.newSprintUser = newSprintUser;
    }
    
    public void unsetNewSprintUser() {
        newSprintUser = new SprintUser__c();
    }
    
    // sprint user list
    public List<SprintUser__c> getSprintUserList() {
        if (getSprintId() == null)
            return new List<SprintUser__c>();
        if (sprintUserList != null)
            return sprintUserList;
            
        try {
            sprintUserList = [
                select IsUnmanaged__c
                     , Availability__c
                     , EstimatedHours__c
                     , ActualHours__c
                     , User__r.Email
                     , User__r.Name
                     , User__c
                     , WorkstreamRole__c
                     , WorkstreamUser__c
                  from SprintUser__c
                 where Sprint__c = :getSprintId()
                   and User__r.IsActive = true
              order by User__r.Name asc
            ];
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }
        
        if (sprintUserList == null)
            return new List<SprintUser__c>();
        return sprintUserList;
    }

    public void setSprintUserList(List<SprintUser__c> sprintUserList) {
        this.sprintUserList = sprintUserList;
        unsetSprintUserOptions();
    }
    
    public Integer getSprintUserListSize() {
        return getSprintUserList().size();
    }    
    
    public SprintUser__c getSprintUser(Id sprintUserId) {
        return new Map<Id, SprintUser__c>(getSprintUserList()).get(sprintUserId);
    }
    
    public Boolean hasSprintUserByUserId(Id userId) {
        for (SprintUser__c sprintUser : getSprintUserList()) {
            if (sprintUser.User__c == userId)
                return true;
        }
        
        return false;
    }
    
    public Boolean hasSprintUserByWorkstreamUserId(Id workstreamUserId) {
        for (SprintUser__c sprintUser : getSprintUserList()) {
            if (sprintUser.WorkstreamUser__c == workstreamUserId)
                return true;
        }
        
        return false;
    }
    
    public void unsetSprintUserList() {
        sprintUserList = null;
    }
    
    // sprint user options
    public List<SelectOption> getSprintUserOptions() {
        if (sprintUserOptions != null)
            return sprintUserOptions;

        // Build cache            
        sprintUserOptions = new List<SelectOption>();
        sprintUserOptions.add(new SelectOption('', '--None--'));

        try {            
            for(SprintUser__c sprintUser : getSprintUserList()) 
                sprintUserOptions.add(new SelectOption(sprintUser.Id, sprintUser.User__r.Name));
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }
        
        return sprintUserOptions;
    }
    
    public void setSprintUserOptions(List<SelectOption> sprintUserOptions) {
        this.sprintUserOptions = sprintUserOptions;
    }
    
    public Integer getSprintUserOptionsSize() {
        return getSprintUserOptions().size();
    }
    
    public void unsetSprintUserOptions() {
        sprintUserOptions = null;
    }
    
    // workstream role options
    public List<SelectOption> getWorkstreamRoleOptions() {
        if (workstreamRoleOptions == null) {
            Workstream__c workstream = new Workstream__c(Id = getSprint().Workstream__c);
            ApexPages.StandardController workstreamController = new ApexPages.StandardController(workstream);
            workstreamRoleOptions = new Workstream_ManageRoles(workstreamController).getWorkstreamRoleOptions();
        }
        
        return workstreamRoleOptions;
    }

    // page references 
    public PageReference insertSprintUser() {
        if (getSprintId() == null)
            addMessage('Internal Error: Sprint ID is null.');
        else if (getNewSprintUser() == null)
            addMessage('Internal Error: New SprintUser is null.');
        else if (getNewSprintUser().User__c == null)
            addMessage('Internal Error: New SprintUser.User__c is null.');
        else if (hasSprintUserByUserId(getNewSprintUser().User__c))
            addMessage('User is already associated with this Sprint.');
        else try {
            SprintUser__c sprintUser = getNewSprintUser();
            sprintUser.Sprint__c = getSprintId();
            sprintUser.IsUnmanaged__c = true;
            upsert sprintUser;
            
            addChangesSavedMessage();
            unsetCachedProperties();  
        } catch (Exception e) {
            ApexPages.addMessages(e);
        } 

        return null;
    }

    public PageReference saveSprintUserList() {
        if (getSprintUserListSize() == 0)
            return null;
        
        try {
            upsert getSprintUserList();
            
            addChangesSavedMessage();
            unsetCachedProperties();     
        } catch (Exception e) {
            ApexPages.addMessages(e);
        } 
        
        return null;
    }

    public PageReference saveSprintUserListAndReturn() {
        saveSprintUserList();
        
        if (getMessageListSize(ApexPages.Severity.ERROR) == 0)
            return new PageReference('/' + getSprintId());

        return null;
    }

    public PageReference deleteSprintUser() {
        if (getPageParam('selectedId') == null)
            addMessage('Internal Error: required parameter "selectedId" is missing');
        else if (getSprintUser(getPageParam('selectedId')) == null)
            addMessage('Internal Error: no matching sprint user for that "selectedId" parameter exists in the list of sprint users: ' + getSprintUserList());
        else if (getSprintUser(getPageParam('selectedId')).IsUnmanaged__c == false)
            addMessage('Not allowed to delete a managed Sprint User from a Sprint.');
        else try {
            delete getSprintUser(getPageParam('selectedId'));

            addChangesSavedMessage();
            unsetCachedProperties();  
        } catch (Exception e) {
            ApexPages.addMessages(e);
        }    
        
        return null;
    }

}