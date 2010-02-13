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

trigger Story_AssignTasksToSprint on Story__c (after update) 
{
    //
    // Build a list of stories that were either:
    // - just assigned to a sprint
    // - just removed from a sprint
    // - just reassigned from one sprint to another
    //

    Set <Id> storyIds = new Set <Id> ();
    
    for(Story__c story : Trigger.new) {
        Story__c previousStory = Trigger.oldMap.get (story.Id);
        
        if (story.Sprint__c == previousStory.Sprint__c)
            continue;
        
        if (story.Sprint__c != null)
            storyIds.add (story.Id);
        if (previousStory.Sprint__c != null)
            storyIds.add (previousStory.Id);
    }

    //
    // No stories changed? Nothing to do.
    //

    if (storyIds.size () == 0)
        return;

    //
    // Once armed with the list of stories, find the related tasks
    //

    Map <Id, Task__c> taskMap = new Map <Id, Task__c> ([
        select Name
             , Story__c
          from Task__c
         where Story__c in : storyIds
           and Status__c != 'Completed' /* System.Label.StatusCompleted */
    ]);

    //
    // No tasks? Nothing to do!
    //
    
    if (taskMap.size () == 0)
        return;

    //
    // Assign the tasks to the new sprint, whether null or not.
    //
    
    List <Task__c> clonedTaskList = taskMap.values ().deepClone(false);
    
    for (Task__c task : clonedTaskList) {
        Story__c story = Trigger.newMap.get (task.Story__c);
        task.Sprint__c = story.Sprint__c;
    }
    
    insert clonedTaskList;
    delete taskMap.values ();
}