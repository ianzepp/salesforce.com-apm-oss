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

trigger Sprint_ReplaceSprintUsersFromWorkstream on Sprint__c (after insert, after update) {
    Set<Id> sprintIdList = new Set<Id>();
    
    for (Sprint__c sprint : Trigger.new) {
        if (Trigger.isInsert)
            continue;
        if (Trigger.oldMap.get(sprint.Id).Workstream__c == sprint.Workstream__c)
            continue;
        if (sprint.Workstream__c == null)
            continue;
        sprintIdList.add(sprint.Id);
    }
    
    if (sprintIdList.size() > 0) 
        delete [
            select Id
              from SprintUser__c
             where Sprint__c in :sprintIdList
               and IsUnmanaged__c = false
        ];
        
    Set<Id> workstreamIdList = new Set<Id>();    
    
    for (Sprint__c sprint : Trigger.new) {
        if (sprint.Workstream__c == null)
            continue;
            
        if (Trigger.isInsert)
            workstreamIdList.add(sprint.Workstream__c);
        else if (Trigger.oldMap.get(sprint.Id).Workstream__c != sprint.Workstream__c)
            workstreamIdList.add(sprint.Workstream__c);
    }
    
    if (workstreamIdList.size() == 0)
        return;
        
    List<SprintUser__c> sprintUserList = new List<SprintUser__c>();
    Map<Id, Workstream__c> workstreamMap = new Map<Id, Workstream__c>([
        select Name
             , (select Availability__c
                     , User__c
                     , Workstream__c
                     , WorkstreamRole__c
                  from WorkstreamUsers__r)
          from Workstream__c
         where Id in :workstreamIdList
    ]);

    for (Sprint__c sprint : Trigger.new) {
        if (sprint.Workstream__c == null)
            continue;
    
        for(WorkstreamUser__c workstreamUser : workstreamMap.get(sprint.Workstream__c).WorkstreamUsers__r)
            sprintUserList.add(new SprintUser__c(
                Sprint__c = sprint.Id,
                WorkstreamUser__c = workstreamUser.Id,
                User__c = workstreamUser.User__c,
                Availability__c = workstreamUser.Availability__c,
                WorkstreamRole__c = workstreamUser.WorkstreamRole__c
            ));
    }
    
    if (sprintUserList.size() > 0)
        insert sprintUserList;
    
}