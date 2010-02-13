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

trigger Task_UpdatePositions on Task__c (after delete, after insert, after undelete) {
    Set<Id> storyIds = new Set<Id>();
    
    if (Trigger.new != null) {
        for (Task__c task : Trigger.new)
            storyIds.add(task.Story__c);
    }

    if (Trigger.old != null) {
        for (Task__c task : Trigger.old)
            storyIds.add(task.Story__c);
    }

    List<Story__c> storyList = [
        select (select Position__c
                  from Tasks__r
              order by Position__c asc)
          from Story__c
         where Id in :storyIds
    ];

    for (Story__c story : storyList) {
    	for (Integer p = 0; p < story.Tasks__r.size(); p ++)
    	   story.Tasks__r[p].Position__c = p + 1;
    	update story.Tasks__r;
    }
}