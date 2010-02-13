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

trigger WorkstreamUser_InsertSprintUsers on WorkstreamUser__c (after insert, after undelete) {
    //
    // Build a list of affected workstreams
    //
    
    Set<Id> workstreamIds = new Set<Id>();
    
    for(WorkstreamUser__c workstreamUser : Trigger.new)
        workstreamIds.add(workstreamUser.Workstream__c);
    
    if (workstreamIds.size() == 0)
        return;
    
    //
    // Get a list of target sprints
    //
    
    List<Sprint__c> sprintList = [
        select Workstream__c
          from Sprint__c
         where IsGeneralBacklog__c = false
           and Workstream__c in :workstreamIds
           and Status__c in ('Not Yet Started', 'In Progress')
    ];

    if (sprintList.size() == 0)
        return;
    
    //
    // For each new workstream user, create a matching sprint user for each sprint
    //

    List<SprintUser__c> sprintUserList = new List<SprintUser__c>();

    for(WorkstreamUser__c workstreamUser : Trigger.new) {
        for(Sprint__c sprint : sprintList) {
            if (sprint.Workstream__c != workstreamUser.Workstream__c)
                continue;
            
            SprintUser__c sprintUser = new SprintUser__c();
            sprintUser.Availability__c = workstreamUser.Availability__c;
            sprintUser.Sprint__c = sprint.Id;
            sprintUser.User__c = workstreamUser.User__c;
            sprintUser.WorkstreamRole__c = workstreamUser.WorkstreamRole__c;
            sprintUser.WorkstreamUser__c = workstreamUser.Id;
            sprintUserList.add(sprintUser);
        }
    }

    if (sprintUserList.size() == 0)
        return;
        
    //
    // Insert sprint users.
    //
    
    insert sprintUserList;
}