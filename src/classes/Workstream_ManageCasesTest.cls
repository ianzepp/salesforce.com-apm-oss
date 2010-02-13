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
private with sharing class Workstream_ManageCasesTest {
    public static testmethod void testGetWorkstreamCase() {
        Case case1 = new Case();
        case1.Subject = 'Test Case';
        insert case1;
 
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        WorkstreamCase__c workstreamCase1 = new WorkstreamCase__c();
        workstreamCase1.Case__c = case1.Id;
        workstreamCase1.Workstream__c = workstream1.Id;
        insert workstreamCase1;

        Workstream_ManageCases workstreamController = new Workstream_ManageCases(new ApexPages.StandardController(workstream1));
        system.assert(null != workstreamController.getWorkstreamCase(workstreamCase1.Id));
        system.assertEquals(case1.Id, workstreamController.getWorkstreamCase(workstreamCase1.Id).Case__c);
    }
    
    public static testmethod void testHasWorkstreamCase() {
        Case case1 = new Case();
        case1.Subject = 'Test Case';
        insert case1;

        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        WorkstreamCase__c workstreamCase1 = new WorkstreamCase__c();
        workstreamCase1.Case__c = case1.Id;
        workstreamCase1.Workstream__c = workstream1.Id;
        insert workstreamCase1;

        Workstream_ManageCases workstreamController = new Workstream_ManageCases(new ApexPages.StandardController(workstream1));
        system.assert(workstreamController.hasWorkstreamCaseByCaseId(case1.Id));
    }

    public static testmethod void testSprintOptions() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Sprint__c sprint2 = new Sprint__c();
        sprint2.Name = 'Sprint#2';
        sprint2.StartsOn__c = Date.today();
        sprint2.CompletesOn__c = Date.today().addDays(1);
        sprint2.Workstream__c = workstream1.Id;
        insert sprint2;
        
        Workstream_ManageCases workstreamController = new Workstream_ManageCases(new ApexPages.StandardController(workstream1));
        system.assertEquals(4, workstreamController.getSprintOptionsSize()); // --None--, General Backlog
    }

    public static testmethod void testSaveWorkstreamCaseList() {
        Case case1 = new Case();
        case1.Subject = 'Test Case';
        insert case1;

        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        WorkstreamCase__c workstreamCase1 = new WorkstreamCase__c();
        workstreamCase1.Case__c = case1.Id;
        workstreamCase1.Workstream__c = workstream1.Id;
        insert workstreamCase1;

        Workstream_ManageCases workstreamController = new Workstream_ManageCases(new ApexPages.StandardController(workstream1));
        workstreamController.saveWorkstreamCaseList();
    }

    public static testmethod void testSaveWorkstreamCaseListAndReturn() {
        Case case1 = new Case();
        case1.Subject = 'Test Case';
        insert case1;

        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        WorkstreamCase__c workstreamCase1 = new WorkstreamCase__c();
        workstreamCase1.Case__c = case1.Id;
        workstreamCase1.Workstream__c = workstream1.Id;
        insert workstreamCase1;

        Workstream_ManageCases workstreamController = new Workstream_ManageCases(new ApexPages.StandardController(workstream1));
        workstreamController.saveWorkstreamCaseListAndReturn();
    }

    public static testmethod void testInsertWorkstreamCase() {
        Case case1 = new Case();
        case1.Subject = 'Test Case';
        insert case1;

        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        WorkstreamCase__c workstreamCase1 = new WorkstreamCase__c();
        workstreamCase1.Case__c = case1.Id;
        workstreamCase1.Workstream__c = workstream1.Id;
        insert workstreamCase1;

        Workstream_ManageCases workstreamController = new Workstream_ManageCases(new ApexPages.StandardController(workstream1));
        workstreamController.getNewWorkstreamCase().Case__c = case1.Id;
        workstreamController.insertWorkstreamCase();
    }
}