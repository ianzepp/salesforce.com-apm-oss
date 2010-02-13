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

trigger Task_InsertTimeEntries on Task__c (after insert, after update) {
    List <Time__c> timeList = new List <Time__c> ();

    for(Task__c task : Trigger.new) {
        Task__c previousTask = Trigger.isUpdate ? Trigger.oldMap.get (task.Id) : null;
        Time__c timeRecord = null;

        if (Trigger.isInsert)
            timeRecord = new Time__c (
                ActualHours__c = task.ActualHours__c,
                EstimatedHours__c = task.EstimatedHours__c,
                Sprint__c = task.Sprint__c,
                Story__c = task.Story__c,
                Task__c = task.Id
            );
        else
            timeRecord = new Time__c (
                ActualHours__c = task.ActualHours__c - previousTask.ActualHours__c,
                EstimatedHours__c = task.EstimatedHours__c - previousTask.EstimatedHours__c,
                Sprint__c = task.Sprint__c,
                Story__c = task.Story__c,
                Task__c = task.Id
            );

        if (timeRecord.ActualHours__c == 0 && timeRecord.EstimatedHours__c == 0)
            continue;
        timeList.add(timeRecord);

        // Determine who is submitting the time
        try {
            SprintUser__c sprintUser = [
                select WorkstreamUser__c
                     , User__c
                  from SprintUser__c
                 where Sprint__c = :task.Sprint__c
                   and WorkstreamUser__r.User__c = :UserInfo.getUserId()
                 limit 1
            ];
            
            timeRecord.SprintUser__c = sprintUser.Id;
            timeRecord.WorkstreamUser__c = sprintUser.WorkstreamUser__c;
            timeRecord.User__c = sprintUser.User__c;
        } catch (System.QueryException e) {
            if (e.getMessage().contains('List has no rows for assignment to SObject'))
                System.debug('Unable to find a matching Sprint User record for userId ' + UserInfo.getUserId());
            else
                task.addError(e.getMessage());
            continue;
        }

        //
        // If there are 100 time records, insert the batch and reset the list
        //
        
        if (timeList.size () >= 100) {
            insert timeList;
            timeList.clear ();
        }
    }
    
    if (timeList.size () > 0)
        insert timeList;
}