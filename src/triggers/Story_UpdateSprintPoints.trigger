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

trigger Story_UpdateSprintPoints on Story__c (after insert, after update, after delete) {
    //
    // Build a list of point-changed sprints 
    //
    
    Set<Id> sprintIds = new Set<Id>();
    
    for(Story__c story : Trigger.isDelete ? Trigger.old : Trigger.new) {
        if (Trigger.isDelete || Trigger.isInsert)
            sprintIds.add(story.Sprint__c);
        else if (story.PointsValue__c != Trigger.oldMap.get(story.Id).PointsValue__c)
            sprintIds.add(story.Sprint__c);
    }
    
    if (sprintIds.size() == 0)
        return;
        
    //
    // Update the sprints. Each sprint's update-points trigger will take care of the rest.
    //
    
    update [
        select Id
          from Sprint__c
         where Id in :sprintIds
    ];
}