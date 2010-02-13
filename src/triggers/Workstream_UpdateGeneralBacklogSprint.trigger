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

trigger Workstream_UpdateGeneralBacklogSprint on Workstream__c(after update) {
    for(Workstream__c workstream : Trigger.new) {
        Workstream__c workstreamOld = Trigger.oldMap.get(workstream.Id);
        
        if (workstream.Name == workstreamOld.Name)
            continue;

        List<Sprint__c> sprintList = [
            select Name
              from Sprint__c
             where Workstream__c = :workstream.Id
               and IsGeneralBacklog__c = true
        ];        

        for(Sprint__c sprint : sprintList)
            sprint.Name = workstream.Name + ' ' + '(Backlog)';
            
        update sprintList;
    }
}