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

trigger WorkstreamUser_UpdateSprintUserRoles on WorkstreamUser__c (after update) {
	//
	// Get a list of affected sprint users
	//
	
    List<SprintUser__c> sprintUserList = [
        select WorkstreamUser__c
          from SprintUser__c
         where WorkstreamUser__c in :Trigger.new
    ];

    if (sprintUserList.size() == 0)
        return;

    //
    // Apply the updates
    //
    
    for(WorkstreamUser__c workstreamUser : Trigger.new) {
    	for(SprintUser__c sprintUser : sprintUserList) {
    		if (sprintUser.WorkstreamUser__c != workstreamUser.Id)
    		    continue;
    		sprintUser.WorkstreamRole__c = workstreamUser.WorkstreamRole__c;
    	}
    }

    update sprintUserList;
}