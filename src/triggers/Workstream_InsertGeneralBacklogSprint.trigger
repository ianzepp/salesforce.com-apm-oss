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

trigger Workstream_InsertGeneralBacklogSprint on Workstream__c (after insert) {
    List<Sprint__c> sprintList = new List<Sprint__c>();
    Integer currentYear = Date.today().year();
    
    for (Workstream__c workstream : Trigger.new)
        sprintList.add(new Sprint__c(
            IsGeneralBacklog__c = true,
            Name = workstream.Name + ' ' + '(Backlog)',
            Workstream__c = workstream.Id,
            StartsOn__c = Date.newInstance(currentYear, 01, 01),
            CompletesOn__c = Date.newInstance(currentYear, 12, 31)
        ));
        
    if (sprintList.size() > 0)
        insert sprintList;
}