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

trigger Sprint_SetCalendarDays on Sprint__c (before insert, before update) {
    for(Sprint__c sprint : Trigger.new) {
        if (sprint.CompletesOn__c == null)
            continue;
        if (sprint.StartsOn__c == null)
            continue;
        sprint.CalendarDays__c = sprint.StartsOn__c.daysBetween(sprint.CompletesOn__c) + 1;
    }
}