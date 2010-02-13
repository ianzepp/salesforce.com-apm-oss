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

public with sharing class Workstream_ManageUsers extends Common_AbstractExtension {
    public Workstream_ManageUsers(ApexPages.StandardController controller) {
        super(controller);
    }
    
    // private vars
    private WorkstreamUser__c newWorkstreamUser = new WorkstreamUser__c();    
    private List<WorkstreamUser__c> workstreamUserList = null;
    private List<SelectOption> workstreamUserOptions = null;
    private List<SelectOption> workstreamRoleOptions = null;
    
    // reset cache
    public void unsetCachedProperties() { 
        unsetNewWorkstreamUser();
        unsetWorkstreamUserList();
        unsetWorkstreamUserOptions();
    }

    // workstream
    public Workstream__c getWorkstream() {
        return (Workstream__c) getControllerRecord();
    }

    public Id getWorkstreamId() {
        return getControllerId();
    } 

    // new workstream user
    public WorkstreamUser__c getNewWorkstreamUser() {
        return newWorkstreamUser;
    }
    
    public void setNewWorkstreamUser(WorkstreamUser__c newWorkstreamUser) {
        this.newWorkstreamUser = newWorkstreamUser;
    }
    
    public void unsetNewWorkstreamUser() {
        newWorkstreamUser = new WorkstreamUser__c();
    }
    
    // workstream user list
    public List<WorkstreamUser__c> getWorkstreamUserList() {
        if (getWorkstreamId() == null)
            return new List<WorkstreamUser__c>();
        if (workstreamUserList != null)
            return workstreamUserList;
            
        try {
            workstreamUserList = [
                select Availability__c
                     , User__r.Email
                     , User__r.Name
                     , User__c
                     , WorkstreamRole__c
                  from WorkstreamUser__c
                 where Workstream__c = :getWorkstreamId()
                   and User__r.IsActive = true
              order by User__r.Name asc
            ];
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }
        
        if (workstreamUserList == null)
            return new List<WorkstreamUser__c>();
        return workstreamUserList;
    }

    public void setWorkstreamUserList(List<WorkstreamUser__c> workstreamUserList) {
        this.workstreamUserList = workstreamUserList;
        unsetWorkstreamUserOptions();
    }
    
    public Integer getWorkstreamUserListSize() {
        return getWorkstreamUserList().size();
    }    
    
    public WorkstreamUser__c getWorkstreamUser(Id workstreamUserId) {
        return new Map<Id, WorkstreamUser__c>(getWorkstreamUserList()).get(workstreamUserId);
    }
    
    public Boolean hasWorkstreamUserByUserId(Id userId) {
        for (WorkstreamUser__c workstreamUser : getWorkstreamUserList()) {
            if (workstreamUser.User__c == userId)
                return true;
        }
        
        return false;
    }
    
    public void unsetWorkstreamUserList() {
        workstreamUserList = null;
    }
    
    // workstream user options
    public List<SelectOption> getWorkstreamUserOptions() {
        if (workstreamUserOptions != null)
            return workstreamUserOptions;

        // Build cache            
        workstreamUserOptions = new List<SelectOption>();
        workstreamUserOptions.add(new SelectOption('', '--None--'));

        try {            
            for(WorkstreamUser__c workstreamUser : getWorkstreamUserList()) 
                workstreamUserOptions.add(new SelectOption(workstreamUser.Id, workstreamUser.User__r.Name));
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }
        
        return workstreamUserOptions;
    }
    
    public void setWorkstreamUserOptions(List<SelectOption> workstreamUserOptions) {
        this.workstreamUserOptions = workstreamUserOptions;
    }
    
    public Integer getWorkstreamUserOptionsSize() {
        return getWorkstreamUserOptions().size();
    }
    
    public void unsetWorkstreamUserOptions() {
        workstreamUserOptions = null;
    }
    
    // workstream role options
    public List<SelectOption> getWorkstreamRoleOptions() {
        if (workstreamRoleOptions == null)
            workstreamRoleOptions = new Workstream_ManageRoles(getController()).getWorkstreamRoleOptions();
        return workstreamRoleOptions;
    }

    // page references 
    public PageReference insertWorkstreamUser() {
        if (getWorkstreamId() == null)
            addMessage('Internal Error: Workstream ID is null.');
        else if (getNewWorkstreamUser() == null)
            addMessage('Internal Error: New WorkstreamUser is null.');
        else if (getNewWorkstreamUser().User__c == null)
            addMessage('Internal Error: New WorkstreamUser.User__c is null.');
        else if (hasWorkstreamUserByUserId(getNewWorkstreamUser().User__c))
            addMessage('User is already associated with this Workstream.');
        else try {
            WorkstreamUser__c workstreamUser = getNewWorkstreamUser();
            workstreamUser.Workstream__c = getWorkstreamId();
            upsert workstreamUser;
            
            addChangesSavedMessage();
            unsetCachedProperties();
        } catch (Exception e) {
            ApexPages.addMessages(e);
        } 

        return null;
    }

    public PageReference saveWorkstreamUserList() {
        if (getWorkstreamUserListSize() == 0)
            return null;
        
        try {
            upsert getWorkstreamUserList();
            
            addChangesSavedMessage();
            unsetCachedProperties();     
        } catch (Exception e) {
            ApexPages.addMessages(e);
        } 
        
        return null;
    }

    public PageReference saveWorkstreamUserListAndReturn() {
        saveWorkstreamUserList();
        
        if (getMessageListSize(ApexPages.Severity.ERROR) == 0)
            return new PageReference('/' + getWorkstreamId());

        return null;
    }

    public PageReference deleteWorkstreamUser() {
        if (getPageParam('selectedId') == null)
            addMessage('Internal Error: required parameter "selectedId" is missing');
        else if (getWorkstreamUser(getPageParam('selectedId')) == null)
            addMessage('Internal Error: no matching workstream user for that "selectedId" parameter exists in the list of workstream users: ' + getWorkstreamUserList());
        else try {
            delete getWorkstreamUser(getPageParam('selectedId'));

            addChangesSavedMessage();
            unsetCachedProperties(); 
        } catch (Exception e) {
            ApexPages.addMessages(e);
        }    
        
        return null;
    }

}