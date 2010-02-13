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

trigger Story_UpdatePositions on Story__c (after delete, after insert, after undelete) {
    Set<Id> sprintIds = new Set<Id>();
    
    if (Trigger.new != null) {
        for (Story__c story : Trigger.new)
            sprintIds.add(story.Sprint__c);
    }

    if (Trigger.old != null) {
        for (Story__c story : Trigger.old)
            sprintIds.add(story.Sprint__c);
    }

    List<Sprint__c> sprintList = [
        select (select Position__c
                  from Stories__r
              order by Position__c asc)
          from Sprint__c
         where Id in :sprintIds
    ];

    for (Sprint__c sprint : sprintList) {
        for (Integer p = 0; p < sprint.Stories__r.size(); p ++)
           sprint.Stories__r[p].Position__c = p + 1;
        update sprint.Stories__r;
    }

}