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
private with sharing class Workstream_ManageUsersTest {
    public static testmethod void testSaveWorkstreamUserList() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        WorkstreamUser__c workstreamUser1 = new WorkstreamUser__c();
        workstreamUser1.Workstream__c = workstream1.Id;
        workstreamUser1.User__c = UserInfo.getUserId();
        insert workstreamUser1;
        
        Workstream_ManageUsers workstreamController = new Workstream_ManageUsers(new ApexPages.StandardController(workstream1));
        workstreamController.saveWorkstreamUserList();
    }

    public static testmethod void testSaveWorkstreamUserListAndReturn() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        WorkstreamUser__c workstreamUser1 = new WorkstreamUser__c();
        workstreamUser1.Workstream__c = workstream1.Id;
        workstreamUser1.User__c = UserInfo.getUserId();
        insert workstreamUser1;
        
        Workstream_ManageUsers workstreamController = new Workstream_ManageUsers(new ApexPages.StandardController(workstream1));
        workstreamController.saveWorkstreamUserListAndReturn();
    }

    public static testmethod void testInsertWorkstreamUser() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        Workstream_ManageUsers workstreamController = new Workstream_ManageUsers(new ApexPages.StandardController(workstream1));
        workstreamController.getNewWorkstreamUser().User__c = UserInfo.getUserId();
        workstreamController.insertWorkstreamUser();
    }

    public static testmethod void testDeleteWorkstreamUser() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        WorkstreamUser__c workstreamUser1 = new WorkstreamUser__c();
        workstreamUser1.Workstream__c = workstream1.Id;
        workstreamUser1.User__c = UserInfo.getUserId();
        insert workstreamUser1;
        
        system.currentPageReference().getParameters().put('selectedId', workstreamUser1.Id);
        Workstream_ManageUsers workstreamController = new Workstream_ManageUsers(new ApexPages.StandardController(workstream1));
        workstreamController.deleteWorkstreamUser();
    }

}