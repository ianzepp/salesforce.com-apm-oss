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

trigger Story_InsertGeneralBacklogSprint on Story__c (before insert, before update) {
    Set<Id> workstreamIds = new Set<Id>();
    
    for (Story__c story : Trigger.new) {
    	if (story.Sprint__c != null)
    	    continue;
        if (story.Workstream__c == null)
            continue;
        workstreamIds.add(story.Workstream__c);
    }
    
    if (workstreamIds.size() == 0)
        return;
        
    Map<Id, Id> workstreamSprintMap = new Map<Id, Id>();  
       
    for (Sprint__c sprint : [
        select Workstream__c
          from Sprint__c
         where Workstream__c in :workstreamIds
           and IsGeneralBacklog__c = true
    ]) workstreamSprintMap.put(sprint.Workstream__c, sprint.Id);
    
    for (Story__c story : Trigger.new) {
        if (story.Sprint__c != null)
            continue;
        if (story.Workstream__c == null)
            continue;
        story.Sprint__c = workstreamSprintMap.get(story.Workstream__c);
    }
}