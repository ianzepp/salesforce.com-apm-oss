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

trigger WorkstreamCase_AssignToGeneralBacklog on WorkstreamCase__c (before insert, before update) {
	//
	// Create a list of unassigned workstream cases
	//
	
    List<WorkstreamCase__c> workstreamCaseList = new List<WorkstreamCase__c>();
    
    for(WorkstreamCase__c workstreamCase : Trigger.new) {
    	if (workstreamCase.Sprint__c != null)
    	    continue;
    	workstreamCaseList.add(workstreamCase);
    }
    
    if (workstreamCaseList.size() == 0)
        return;
        
    //
    // Build a list of associated workstreams, to find general backlogs
    //
    
    Set<Id> workstreamIds = new Set<Id>();
    
    for(WorkstreamCase__c workstreamCase : workstreamCaseList)
        workstreamIds.add(workstreamCase.Workstream__c);
      
    if (workstreamIds.size() == 0)
        system.assert(false, 'Internal Error: we have matching workstream cases but no extracted workstreams'
                           + ', workstreamCaseList = ' + workstreamCaseList
                           + ', workstreamIds = ' + workstreamIds
                           + ', Trigger.New = ' + Trigger.new
                           + '. Please forward this error message to your support provider.');
        
    //
    // Fetch the associated general backlog sprints
    //
    
    List<Sprint__c> sprintList = [
        select Workstream__c
          from Sprint__c
         where Workstream__c in :workstreamIds
           and IsGeneralBacklog__c = true
    ];

    if (sprintList.size() == 0 || sprintList.size() != workstreamIds.size())
        system.assert(false, 'Internal Error: we have matching workstream cases but not enough general backlog sprints'
                           + ', sprintList = ' + sprintList
                           + ', workstreamCaseList = ' + workstreamCaseList
                           + ', workstreamIds = ' + workstreamIds
                           + ', Trigger.New = ' + Trigger.new
                           + '. Please forward this error message to your support provider.');
        
    //
    // Assign the workstream cases to the right general backlog sprint
    //
    
    for(WorkstreamCase__c workstreamCase : Trigger.new) {
    	for(Sprint__c sprint : sprintList) {
    		if (sprint.Workstream__c != workstreamCase.Workstream__c)
    		    continue;
    		workstreamCase.Sprint__c = sprint.Id;
    	}
    }

}