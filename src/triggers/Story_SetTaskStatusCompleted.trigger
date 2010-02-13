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

trigger Story_SetTaskStatusCompleted on Story__c (before insert, before update) {
    for(Story__c story : Trigger.new) {
        if (story.TotalTasks__c == 0)
            continue;
        if (story.NotYetStartedTasks__c != 0)
            continue;
        if (story.InProgressTasks__c != 0)
            continue;
        if (story.BlockedTasks__c != 0)
            continue;
        story.TaskStatus__c = 'Completed';
    }
}