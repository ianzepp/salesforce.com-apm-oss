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

public with sharing class Workstream_ManageCases extends Common_AbstractExtension {
    public Workstream_ManageCases(ApexPages.StandardController controller) {
        super(controller);
    }

    // Private vars
    private WorkstreamCase__c newWorkstreamCase = new WorkstreamCase__c();
    private Sprint__c backlogSprint = null;
    private List<WorkstreamCase__c> workstreamCaseList = null;
    private List<SelectOption> sprintOptions = null;
     
    // Reset cache
    public void unsetCachedProperties() { 
        unsetNewWorkstreamCase();
        unsetWorkstreamCaseList();
    }

    // workstream
    public Workstream__c getWorkstream() {
        return (Workstream__c) getControllerRecord();
    }

    public Id getWorkstreamId() {
        return getControllerId();
    } 

    // backlog sprint
    public Sprint__c getBacklogSprint() {
    	if (backlogSprint == null) try {
    		backlogSprint = [
    		    select Name
    		      from Sprint__c
    		     where Workstream__c = :getWorkstreamId()
    		       and IsGeneralBacklog__c = true
    		     limit 1
    		];
    	} catch (System.DmlException dmlException) {
    		addExceptionMessage(dmlException);
    	}
    	
    	return backlogSprint;
    }

    public void unsetBacklogSprint() {
    	backlogSprint = null;
    }

    // Workstream case
    public WorkstreamCase__c getNewWorkstreamCase() {
        return newWorkstreamCase;
    }

    public void unsetNewWorkstreamCase() {
        newWorkstreamCase = new WorkstreamCase__c();
    }

    // workstream case list
    public List<WorkstreamCase__c> getWorkstreamCaseList() {
        if (workstreamCaseList != null)
            return workstreamCaseList;
            
        if (getWorkstreamId() == null)
            return new List<WorkstreamCase__c>();
        
        try {
            workstreamCaseList = [
               select Name
                    , Case__r.CaseNumber
                    , Case__r.Priority
                    , Case__r.Status
                    , Case__r.Subject
                    , Case__c
                    , ResolutionStatus__c
                    , Sprint__r.IsGeneralBacklog__c
                    , Sprint__c
                    , Story__r.Name
                    , Story__c
                    , Workstream__c
                 from WorkstreamCase__c
                where Workstream__c = :getWorkstreamId()
             order by Sprint__r.Name asc
                    , Story__r.Name desc
            ];
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }
        
        if (workstreamCaseList == null)
            return new List<WorkstreamCase__c>();
            
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
    }
    
    // sprint options
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
                 where Workstream__c = :getWorkstreamId()
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
    
    // Page actions
    public PageReference insertWorkstreamCase() {
        if (getWorkstreamId() == null)
            addMessage('Workstream ID is null');
        else if (getWorkstream() == null)
            addMessage('Workstream is null');
        else if (getNewWorkstreamCase() == null)
            addMessage('New WorkstreamCase ID is null');  
        else if (getNewWorkstreamCase().Case__c == null)
            addMessage('New WorkstreamCase.Case__c ID is null');
        else if (hasWorkstreamCaseByCaseId(getNewWorkstreamCase().Case__c))
            addMessage('Case is already associated with this Workstream.');
        else try {
            WorkstreamCase__c workstreamCase = getNewWorkstreamCase();
            workstreamCase.Workstream__c = getWorkstreamId();
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
            return new PageReference('/' + getWorkstreamId());

        return null;
    }

    public PageReference deleteWorkstreamCase() {
        if (getPageParam('selectedId') == null)
            addMessage('Required parameter "selectedId" is missing');
        else if (getWorkstreamCase(getPageParam('selectedId')) == null)
            addMessage('No matching story task for that "selectedId" parameter exists in the list of workstream cases: ' + getWorkstreamCaseList());
        else try {
        	delete getWorkstreamCase(getPageParam('selectedId'));
        	
            addChangesSavedMessage();
            unsetCachedProperties();        
        } catch (System.DmlException dmlException) {
            addExceptionMessage(dmlException);
        }

        return null;
    }
}