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

trigger Sprint_ReplaceStoryWorkstreams on Sprint__c (after update) {
    Map<Id, Id> sprintWorkstreamMap = new Map<Id, Id>();
    
    for(Sprint__c sprint : Trigger.new) {
        Sprint__c sprintOld = Trigger.oldMap.get(sprint.Id);
        
        if (sprint.Workstream__c != sprintOld.Workstream__c)
            sprintWorkstreamMap.put(sprint.Id, sprint.Workstream__c); 
    }

    if (sprintWorkstreamMap.size() == 0)
        return;
    
    List<Story__c> storyList = [
        select Workstream__c
             , Sprint__c
          from Story__c
         where Sprint__c in :sprintWorkstreamMap.keySet()
    ];
    
    for(Story__c story : storyList)
        story.Workstream__c = sprintWorkstreamMap.get(story.Sprint__c);

    update storyList;
}