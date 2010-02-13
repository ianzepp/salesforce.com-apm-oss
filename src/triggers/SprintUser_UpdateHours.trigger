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

trigger SprintUser_UpdateHours on SprintUser__c (before update) {
    //
    // Reset all hours
    //
    
    for(SprintUser__c sprintUser : Trigger.new) {
        sprintUser.EstimatedHours__c = 0;
        sprintUser.ActualHours__c = 0;
    }
    
    //
    // Create a set of sprints to search
    //
    
    Set<Id> sprintIds = new Set<Id>();
    
    for(SprintUser__c sprintUser : Trigger.new)
        sprintIds.add(sprintUser.Sprint__c);
    
    //
    // Fetch a list of tasks in that sprint
    //
    
    List<Task__c> taskList = [
        select Sprint__c
             , SprintUser__c
             , EstimatedHours__c
             , ActualHours__c
          from Task__c
         where Sprint__c in :sprintIds
           and SprintUser__c in :Trigger.new
    ];
    
    //
    // Update from related tasks
    //
    
    for(Task__c task : taskList) {
        for(SprintUser__c sprintUser : Trigger.new) {
            if (sprintUser.Sprint__c != task.Sprint__c)
                continue;
            if (sprintUser.Id != task.SprintUser__c)
                continue;
                
            sprintUser.EstimatedHours__c += task.EstimatedHours__c;
            sprintUser.ActualHours__c += task.ActualHours__c;
        }
    }
    
}