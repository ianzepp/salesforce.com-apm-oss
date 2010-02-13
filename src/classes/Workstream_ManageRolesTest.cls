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
private with sharing class Workstream_ManageRolesTest {
    public static testmethod void testInsertWorkstreamRole() {
        Workstream__c workstream = new Workstream__c();
        workstream.Name = 'Workstream#1';
        insert workstream;

        Workstream_ManageRoles workstreamController = new Workstream_ManageRoles(new ApexPages.StandardController(workstream));
        workstreamController.insertWorkstreamRole();
    }
    
    public static testmethod void testSaveWorkstreamRoleList() {
        Workstream__c workstream = new Workstream__c();
        workstream.Name = 'Workstream#1';
        insert workstream;

        WorkstreamRole__c workstreamRole1 = new WorkstreamRole__c();
        workstreamRole1.Name = 'WorkstreamRole#1';
        workstreamRole1.IsGlobal__c = true;
        insert workstreamRole1;

        Workstream_ManageRoles workstreamController = new Workstream_ManageRoles(new ApexPages.StandardController(workstream));
        workstreamController.saveWorkstreamRoleList();
    }
    
    public static testmethod void testDeleteWorkstreamRole() {
        Workstream__c workstream = new Workstream__c();
        workstream.Name = 'Workstream#1';
        insert workstream;

        WorkstreamRole__c workstreamRole1 = new WorkstreamRole__c();
        workstreamRole1.Name = 'WorkstreamRole#1';
        workstreamRole1.IsGlobal__c = true;
        insert workstreamRole1;

        Workstream_ManageRoles workstreamController = new Workstream_ManageRoles(new ApexPages.StandardController(workstream));
        workstreamController.setPageParam('selectedId', workstreamRole1.Id);
        workstreamController.saveWorkstreamRoleList();
    }
    
    public static testmethod void testCancel() {
        Workstream__c workstream = new Workstream__c();
        Workstream_ManageRoles workstreamController = new Workstream_ManageRoles(new ApexPages.StandardController(workstream));
        workstreamController.cancel();
    }
    
    public static testmethod void testSaveWorkstreamRoleListAndInsert() { 
        Workstream__c workstream = new Workstream__c();
        workstream.Name = 'Workstream#1';
        insert workstream;

        WorkstreamRole__c workstreamRole1 = new WorkstreamRole__c();
        workstreamRole1.Name = 'WorkstreamRole#1';
        workstreamRole1.IsGlobal__c = true;
        insert workstreamRole1;

        Workstream_ManageRoles workstreamController = new Workstream_ManageRoles(new ApexPages.StandardController(workstream));
        workstreamController.saveWorkstreamRoleListAndInsert();
    }
    
    public static testmethod void testEnableWorkstreamRoleIsInlineEdit() {
        Workstream__c workstream = new Workstream__c();
        workstream.Name = 'Workstream#1';
        insert workstream;

        WorkstreamRole__c workstreamRole1 = new WorkstreamRole__c();
        workstreamRole1.Name = 'WorkstreamRole#1';
        workstreamRole1.IsGlobal__c = true;
        insert workstreamRole1;

        Workstream_ManageRoles workstreamController = new Workstream_ManageRoles(new ApexPages.StandardController(workstream));
        workstreamController.setPageParam('selectedId', workstreamRole1.Id);
        workstreamController.enableWorkstreamRoleIsInlineEdit();
    }
    
    public static testmethod void testCancelWorkstreamRoleIsInlineEdit() {
        Workstream__c workstream = new Workstream__c();
        workstream.Name = 'Workstream#1';
        insert workstream;

        WorkstreamRole__c workstreamRole1 = new WorkstreamRole__c();
        workstreamRole1.Name = 'WorkstreamRole#1';
        workstreamRole1.IsGlobal__c = true;
        insert workstreamRole1;

        Workstream_ManageRoles workstreamController = new Workstream_ManageRoles(new ApexPages.StandardController(workstream));
        workstreamController.setPageParam('selectedId', workstreamRole1.Id);
        workstreamController.cancelWorkstreamRoleIsInlineEdit();
    }
    
    public static testmethod void testCancelInsertWorkstreamRole() {
        Workstream__c workstream = new Workstream__c();
        workstream.Name = 'Workstream#1';
        insert workstream;

        Workstream_ManageRoles workstreamController = new Workstream_ManageRoles(new ApexPages.StandardController(workstream));
        workstreamController.insertWorkstreamRole();
        workstreamController.cancelInsertWorkstreamRole();
    }
 
    public static testmethod void testGetWorkstream() {
        Workstream__c workstream = new Workstream__c();
        Workstream_ManageRoles workstreamController = new Workstream_ManageRoles(new ApexPages.StandardController(workstream));
        workstreamController.getWorkstream();
        workstreamController.getWorkstream(); // caching
    }   

    public static testmethod void testGetWorkstreamRoleList() {
        Workstream__c workstream = new Workstream__c();
        Workstream_ManageRoles workstreamController = new Workstream_ManageRoles(new ApexPages.StandardController(workstream));
        workstreamController.getWorkstreamRoleList();
        workstreamController.getWorkstreamRoleList(); // caching
    }   

    public static testmethod void testSetWorkstreamRoleList() {
        Workstream__c workstream = new Workstream__c();
        Workstream_ManageRoles workstreamController = new Workstream_ManageRoles(new ApexPages.StandardController(workstream));
        workstreamController.setWorkstreamRoleList(new List<WorkstreamRole__c>());
    }   

    public static testmethod void testUnsetWorkstreamRoleList() {
        Workstream__c workstream = new Workstream__c();
        Workstream_ManageRoles workstreamController = new Workstream_ManageRoles(new ApexPages.StandardController(workstream));
        workstreamController.unsetWorkstreamRoleList();
    }   

    public static testmethod void testGetWorkstreamRoleOptions() {
        Workstream__c workstream = new Workstream__c();
        workstream.Name = 'Workstream#1';
        insert workstream;

        WorkstreamRole__c workstreamRole1 = new WorkstreamRole__c();
        workstreamRole1.Name = 'WorkstreamRole#1';
        workstreamRole1.IsGlobal__c = true;
        insert workstreamRole1;

        Workstream_ManageRoles workstreamController = new Workstream_ManageRoles(new ApexPages.StandardController(workstream));
        workstreamController.getWorkstreamRoleOptions();
        workstreamController.getWorkstreamRoleOptions(); // caching
    }   

    public static testmethod void testSetWorkstreamRoleOptions() {
        Workstream__c workstream = new Workstream__c();
        Workstream_ManageRoles workstreamController = new Workstream_ManageRoles(new ApexPages.StandardController(workstream));
        workstreamController.setWorkstreamRoleOptions(new List<SelectOption>());
    }   

    public static testmethod void testUnsetWorkstreamRoleOptions() {
        Workstream__c workstream = new Workstream__c();
        Workstream_ManageRoles workstreamController = new Workstream_ManageRoles(new ApexPages.StandardController(workstream));
        workstreamController.unsetWorkstreamRoleOptions();
    }   

    public static testmethod void testGetWorkstreamRole() {
        Workstream__c workstream = new Workstream__c();
        workstream.Name = 'Workstream#1';
        insert workstream;

        WorkstreamRole__c workstreamRole1 = new WorkstreamRole__c();
        workstreamRole1.Name = 'WorkstreamRole#1';
        workstreamRole1.IsGlobal__c = true;
        insert workstreamRole1;

        Workstream_ManageRoles workstreamController = new Workstream_ManageRoles(new ApexPages.StandardController(workstream));
        workstreamController.getWorkstreamRole(workstreamRole1.Id);
    }   
    
    public static testmethod void testGetWorkstreamRoleListIsInlineEdit() {
        Workstream__c workstream = new Workstream__c();
        workstream.Name = 'Workstream#1';
        insert workstream;

        WorkstreamRole__c workstreamRole1 = new WorkstreamRole__c();
        workstreamRole1.Name = 'WorkstreamRole#1';
        workstreamRole1.IsGlobal__c = true;
        insert workstreamRole1;

        Workstream_ManageRoles workstreamController = new Workstream_ManageRoles(new ApexPages.StandardController(workstream));
        workstreamController.getWorkstreamRoleListIsInlineEdit();
        workstreamController.getWorkstreamRoleListIsInlineEdit(); // caching
    }   

    public static testmethod void testUnsetWorkstreamRoleListIsInlineEdit() {
        Workstream__c workstream = new Workstream__c();
        Workstream_ManageRoles workstreamController = new Workstream_ManageRoles(new ApexPages.StandardController(workstream));
        workstreamController.unsetWorkstreamRoleListIsInlineEdit();
    }

    public static testmethod void testUnsetCachedProperties() {
        Workstream__c workstream = new Workstream__c();
        Workstream_ManageRoles workstreamController = new Workstream_ManageRoles(new ApexPages.StandardController(workstream));
        workstreamController.unsetCachedProperties();
    }
}