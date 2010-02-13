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

@IsTest
private with sharing class SprintUser_SetIsInlineEditUncheckedTest {
    public static testmethod void test() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
        WorkstreamUser__c workstreamUser1 = new WorkstreamUser__c();
        workstreamUser1.User__c = UserInfo.getUserId();
        workstreamUser1.Workstream__c = workstream1.Id;
        insert workstreamUser1;

        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        SprintUser__c sprintUser1 = new SprintUser__c();
        sprintUser1.Sprint__c = sprint1.Id;
        sprintUser1.WorkstreamUser__c = workstreamUser1.Id;
        sprintUser1.IsInlineEdit__c = true;
        sprintUser1.User__c = UserInfo.getUserId();
        insert sprintUser1;

        system.assertEquals(false, [
            select IsInlineEdit__c
              from SprintUser__c
             where Id = :sprintUser1.Id
        ].IsInlineEdit__c);
    }
}