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
private with sharing class Sprint_ManageUsersTest {
    public static testmethod void testInsertSprintUser() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Sprint_ManageUsers sprintController = new Sprint_ManageUsers(new ApexPages.StandardController(sprint1));
        sprintController.getNewSprintUser().User__c = UserInfo.getUserId();
        sprintController.insertSprintUser();
    }

    public static testmethod void testSaveSprintUserList() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        WorkstreamUser__c workstreamUser1 = new WorkstreamUser__c();
        workstreamUser1.Workstream__c = workstream1.Id;
        workstreamUser1.User__c = UserInfo.getUserId();
        insert workstreamUser1;
        
        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        SprintUser__c sprintUser1 = [
            select Id
              from SprintUser__c
             limit 1
        ];

        Sprint_ManageUsers sprintController = new Sprint_ManageUsers(new ApexPages.StandardController(sprint1));
        sprintController.saveSprintUserList();
    }

    public static testmethod void testSaveSprintUserListAndReturn() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        WorkstreamUser__c workstreamUser1 = new WorkstreamUser__c();
        workstreamUser1.Workstream__c = workstream1.Id;
        workstreamUser1.User__c = UserInfo.getUserId();
        insert workstreamUser1;
        
        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        SprintUser__c sprintUser1 = [
            select Id
              from SprintUser__c
             limit 1
        ];

        Sprint_ManageUsers sprintController = new Sprint_ManageUsers(new ApexPages.StandardController(sprint1));
        sprintController.saveSprintUserListAndReturn();
    }

    public static testmethod void testDeleteSprintUser() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        WorkstreamUser__c workstreamUser1 = new WorkstreamUser__c();
        workstreamUser1.Workstream__c = workstream1.Id;
        workstreamUser1.User__c = UserInfo.getUserId();
        insert workstreamUser1;
        
        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        SprintUser__c sprintUser1 = [
            select Id
              from SprintUser__c
             where Sprint__c = :sprint1.Id
             limit 1
        ];

        ApexPages.currentPage().getParameters().put('selectedId', sprintUser1.Id);

        Sprint_ManageUsers sprintController = new Sprint_ManageUsers(new ApexPages.StandardController(sprint1));
        sprintController.deleteSprintUser();
    }

    public static testmethod void testGetSprint() {
        Sprint__c sprint1 = new Sprint__c(); 
        Sprint_ManageUsers sprintController = new Sprint_ManageUsers(new ApexPages.StandardController(sprint1));
        sprintController.getSprint();
    }

    public static testmethod void testSetNewSprintUser() {
        Sprint__c sprint1 = new Sprint__c(); 
        Sprint_ManageUsers sprintController = new Sprint_ManageUsers(new ApexPages.StandardController(sprint1));
        sprintController.setNewSprintUser(new SprintUser__c());
    }

    public static testmethod void testSetSprintUserList() {
        Sprint__c sprint1 = new Sprint__c(); 
        Sprint_ManageUsers sprintController = new Sprint_ManageUsers(new ApexPages.StandardController(sprint1));
        sprintController.setSprintUserList(new List<SprintUser__c>());
    }

    public static testmethod void testHasSprintUserByWorkstreamUserId() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        WorkstreamUser__c workstreamUser1 = new WorkstreamUser__c();
        workstreamUser1.Workstream__c = workstream1.Id;
        workstreamUser1.User__c = UserInfo.getUserId();
        insert workstreamUser1;
        
        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;

        Sprint_ManageUsers sprintController = new Sprint_ManageUsers(new ApexPages.StandardController(sprint1));
        system.assert(sprintController.hasSprintUserByWorkstreamUserId(workstreamUser1.Id));
    }

    public static testmethod void testGetSprintUserOptions() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        WorkstreamUser__c workstreamUser1 = new WorkstreamUser__c();
        workstreamUser1.Workstream__c = workstream1.Id;
        workstreamUser1.User__c = UserInfo.getUserId();
        insert workstreamUser1;
        
        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;

        Sprint_ManageUsers sprintController = new Sprint_ManageUsers(new ApexPages.StandardController(sprint1));
        system.assert(null != sprintController.getSprintUserOptions());
        system.assertEquals(2, sprintController.getSprintUserOptions().size());
    }

    public static testmethod void testSetSprintUserOptions() {
        Sprint__c sprint1 = new Sprint__c(); 
        Sprint_ManageUsers sprintController = new Sprint_ManageUsers(new ApexPages.StandardController(sprint1));
        sprintController.setSprintUserOptions(new List<SelectOption>());
    }

    public static testmethod void testGetWorkstreamRoleOptions() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;

        Sprint_ManageUsers sprintController = new Sprint_ManageUsers(new ApexPages.StandardController(sprint1));
        system.assert(null != sprintController.getWorkstreamRoleOptions());
    }

}