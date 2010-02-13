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

trigger Task_UpdateSprintUserHours on Task__c (after delete, after insert, after update) {
    //
    // Build a list of affected sprint users
    //
    
    Set<Id> sprintUserIds = new Set<Id>();
    
    for(Task__c task : Trigger.isDelete ? Trigger.old : Trigger.new) {
        Task__c taskOld = Trigger.isUpdate ? Trigger.oldMap.get(task.Id) : null;  
        
        if (Trigger.isDelete || Trigger.isInsert)
           sprintUserIds.add(task.SprintUser__c);
           
        if (taskOld == null)
           continue;

        // Change in hours?              
        if (task.EstimatedHours__c != taskOld.EstimatedHours__c)
           sprintUserIds.add(task.SprintUser__c);
        if (task.ActualHours__c != taskOld.ActualHours__c)
           sprintUserIds.add(task.SprintUser__c);
           
        // Change in sprint user? Could be none, one, or both
        if (task.SprintUser__c != taskOld.SprintUser__c && task.SprintUser__c != null)
              sprintUserIds.add(task.SprintUser__c);
        if (task.SprintUser__c != taskOld.SprintUser__c && taskOld.SprintUser__c != null)
           sprintUserIds.add(taskOld.SprintUser__c);
    }

    if (sprintUserIds.size() == 0)
        return;
        
    //
    // Simple query - update
    //
    
    update [
        select Id
          from SprintUser__c
         where Id in :sprintUserIds
    ];
}