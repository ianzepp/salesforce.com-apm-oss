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

public with sharing class Workstream_ManageRoles extends Common_AbstractExtension {
    public Workstream_ManageRoles(ApexPages.StandardController controller) {
        super(controller);
    }

    // private vars
    private Boolean workstreamRoleListIsInlineEdit = null; 
    private List<WorkstreamRole__c> workstreamRoleList = null;
    private List<SelectOption> workstreamRoleOptions = null;
    
    // reset cache
    public void unsetCachedProperties() {
        unsetWorkstreamRoleList();
        unsetWorkstreamRoleListIsInlineEdit();
    }

    // workstream
    public Workstream__c getWorkstream() {
        return (Workstream__c) getControllerRecord();
    }

    public Id getWorkstreamId() {
        return getControllerId();
    } 

    // workstream role list
    public List<WorkstreamRole__c> getWorkstreamRoleList() {
        if (workstreamRoleList != null)
            return workstreamRoleList;
            
        try {
            workstreamRoleList = new List<WorkstreamRole__c>([
                select Name
                     , IsActive__c
                     , IsGlobal__c
                     , IsInlineEdit__c
                     , Workstream__c
                  from WorkstreamRole__c
                 where Workstream__c = null
                    or Workstream__c = :getWorkstreamId()
              order by Name asc
            ]);
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }
        
        if (workstreamRoleList == null)
            workstreamRoleList = new List<WorkstreamRole__c>();
            
        return workstreamRoleList;
    }
    
    public void setWorkstreamRoleList(List<WorkstreamRole__c> workstreamRoleList) {
        this.workstreamRoleList = workstreamRoleList;
    }
    
    public Integer getWorkstreamRoleListSize() {
        return getWorkstreamRoleList().size();
    }
    
    public WorkstreamRole__c getWorkstreamRole(Id workstreamRoleId) {
        return new Map<Id, WorkstreamRole__c>(getWorkstreamRoleList()).get(workstreamRoleId);
    }
    
    public void unsetWorkstreamRoleList() {
        workstreamRoleList = null;
    }
    
    // workstream role options
    public List<SelectOption> getWorkstreamRoleOptions() {
        if (workstreamRoleOptions != null)
            return workstreamRoleOptions;
            
        // Build cache
        workstreamRoleOptions = new List<SelectOption>();
        workstreamRoleOptions.add(new SelectOption('', '--None--'));

        for(WorkstreamRole__c workstreamRole : getWorkstreamRoleList()) {
            if (workstreamRole.IsActive__c == false)
                continue;
            workstreamRoleOptions.add(new SelectOption(workstreamRole.Id, workstreamRole.Name));
        }
            
        return workstreamRoleOptions;
    }
    
    public void setWorkstreamRoleOptions(List<SelectOption> workstreamRoleOptions) {
        this.workstreamRoleOptions = workstreamRoleOptions;
    }
    
    public void unsetWorkstreamRoleOptions() {
        workstreamRoleOptions = null;
    }    

    // inline edit
    public Boolean getWorkstreamRoleListIsInlineEdit() {
        if (workstreamRoleListIsInlineEdit != null)
            return workstreamRoleListIsInlineEdit;
            
        workstreamRoleListIsInlineEdit = false;
        
        for(WorkstreamRole__c workstreamRole : getWorkstreamRoleList()) {
            if (workstreamRoleListIsInlineEdit == true)
                break;
            if (workstreamRole.IsInlineEdit__c == false)
                continue;

            workstreamRoleListIsInlineEdit = true;
        }
        
        return workstreamRoleListIsInlineEdit;
    }
    
    public void unsetWorkstreamRoleListIsInlineEdit() { 
        workstreamRoleListIsInlineEdit = null;
    }

    // insert role
    public PageReference insertWorkstreamRole() {
        WorkstreamRole__c workstreamRole = new WorkstreamRole__c(
            IsActive__c = true,
            IsInlineEdit__c = true
        );
        
        if (getWorkstreamRoleListSize() == 0)
            getWorkstreamRoleList().add(workstreamRole);
        else
            getWorkstreamRoleList().add(0, workstreamRole);

        unsetWorkstreamRoleListIsInlineEdit();
        return null;
    }

    public PageReference saveWorkstreamRoleList() {
        if (getWorkstreamRoleListSize() == 0)
            addMessage('Internal Error: getWorkstreamRoleListSize() == 0');
        else try {        
            for(WorkstreamRole__c workstreamRole : getWorkstreamRoleList()) {
                if (workstreamRole.IsGlobal__c == true)
                    workstreamRole.Workstream__c = null;
                else 
                    workstreamRole.Workstream__c = getWorkstreamId();
            }

            upsert getWorkstreamRoleList();

            addChangesSavedMessage();
            unsetCachedProperties();
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }
    
        return null;
    }

    public PageReference saveWorkstreamRoleListAndInsert() {
        if (getWorkstreamRoleListSize() == 0)
            addMessage('Internal Error: getWorkstreamRoleListSize() == 0');
        else try {        
            for(WorkstreamRole__c workstreamRole : getWorkstreamRoleList()) {
                if (workstreamRole.IsGlobal__c == true)
                    workstreamRole.Workstream__c = null;
                else 
                    workstreamRole.Workstream__c = getWorkstreamId();
            }

            upsert getWorkstreamRoleList();

            addChangesSavedMessage();
            insertWorkstreamRole();
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }
    
        return null;
    }

    public PageReference saveWorkstreamRoleListAndReturn() {
        saveWorkstreamRoleList();
        
        if (getMessageListSize(ApexPages.Severity.ERROR) == 0)
            return new PageReference('/' + getWorkstreamId());

        return null;
    }

    public PageReference enableWorkstreamRoleIsInlineEdit() {
        if (getPageParam('selectedId') == null)
            addMessage('Required parameter "selectedId" is missing');
        else if (getWorkstreamRole(getPageParam('selectedId')) == null)
            addMessage('No matching user role for that "selectedId" parameter exists in the list of user roles: ' + getWorkstreamRoleList());
        else
            getWorkstreamRole(getPageParam('selectedId')).IsInlineEdit__c = true;
            
        unsetWorkstreamRoleListIsInlineEdit();
        return null;
    }

    public PageReference cancelWorkstreamRoleIsInlineEdit() {
        if (getPageParam('selectedId') == null)
            addMessage('Required parameter "selectedId" is missing');
        else if (getWorkstreamRole(getPageParam('selectedId')) == null)
            addMessage('No matching user role for that "selectedId" parameter exists in the list of user roles: ' + getWorkstreamRoleList());
        else
            getWorkstreamRole(getPageParam('selectedId')).IsInlineEdit__c = false;
            
        unsetWorkstreamRoleListIsInlineEdit();
        return null;
    }

    public PageReference cancelInsertWorkstreamRole() {
        if (getWorkstreamRoleListSize() != 0)
            getWorkstreamRoleList().remove(0); // new roles are always created at the front.
        return null;
    }
    
    public PageReference cancel() {
        unsetCachedProperties();
        return null;
    } 

    public PageReference deleteWorkstreamRole() {
        if (getPageParam('selectedId') == null)
            addMessage('Required parameter "selectedId" is missing');
        else if (getWorkstreamRole(getPageParam('selectedId')) == null)
            addMessage('No matching user role for that "selectedId" parameter exists in the list of user roles: ' + getWorkstreamRoleList());
        else
            delete getWorkstreamRole(getPageParam('selectedId'));

        unsetCachedProperties();        
        return null;
    }
}