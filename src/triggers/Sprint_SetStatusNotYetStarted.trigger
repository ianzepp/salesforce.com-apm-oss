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

trigger Sprint_SetStatusNotYetStarted on Sprint__c (before insert, before update) {
    for(Sprint__c sprint : Trigger.new) {
        if (sprint.IsAutomatic__c != 'Automatic')
            continue;
        if (sprint.Status__c == 'Not Yet Started')
            continue;
        if (sprint.StartsOn__c <= Date.today())
            continue;
        sprint.Status__c = 'Not Yet Started';
    }
}