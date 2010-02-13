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

trigger Sprint_ValidateGeneralBacklogDeletion on Sprint__c (before delete) {
    Map<Id, Sprint__c> deleteableSprintMap = new Map<Id, Sprint__c>([
        select Id
          from Sprint__c
         where Id in :Trigger.old
           and Workstream__r.IsActive__c = false
    ]);
    
    for(Sprint__c sprint : Trigger.old) {
        if (sprint.IsGeneralBacklog__c == false)
            continue;
        if (deleteableSprintMap.containsKey(sprint.Id))
            continue;
            
        sprint.addError(System.Label.Sprint_ErrorCannotDeleteIfWorkstreamActive);
    }
}