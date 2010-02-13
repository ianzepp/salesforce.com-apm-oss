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

trigger Sprint_UpdatePoints on Sprint__c (before update) {
    //
    // Reset all sprint points to 0
    //
    
    for(Sprint__c sprint : Trigger.new)
        sprint.StoryPoints__c = 0;
        
    //
    // Sum up story points
    //
    
    Map<Id, Sprint__c> sprintMap = new Map<Id, Sprint__c>(Trigger.new);
    
    for(Story__c story : [
        select PointsValue__c
             , Sprint__c
          from Story__c
         where Sprint__c in :Trigger.new
    ]) sprintMap.get(story.Sprint__c).StoryPoints__c += story.PointsValue__c;
}