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

trigger Sprint_UpdateTaskableHours on Sprint__c (before update) {
    Map <Id, SprintUser__c> sprintUserMap = new Map <Id, SprintUser__c> ([
        select AvailabilityRatio__c
             , Sprint__r.Workstream__r.DailyCapability__c
             , Sprint__c
          from SprintUser__c
         where Sprint__c in :Trigger.new
    ]);
    
    if (sprintUserMap.size () == 0)
        return;
    
    for(Sprint__c sprint : Trigger.new)
        sprint.TaskableHours__c = 0;
    
    for(SprintUser__c sprintUser : sprintUserMap.values()) {
        Sprint__c sprint = Trigger.newMap.get (SprintUser.sprint__c);
        sprint.TaskableHours__c += sprintUser.AvailabilityRatio__c 
                                 * sprintUser.Sprint__r.Workstream__r.DailyCapability__c
                                 * sprint.CalendarDays__c;
    }
}