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

@isTest
private with sharing class WorkstreamCase_RedirectToManageTest {
    public static testmethod void testInstance() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        Case case1 = new Case();
        case1.Subject = 'Test Case';
        insert case1;

        WorkstreamCase__c workstreamCase1 = new WorkstreamCase__c();
        workstreamCase1.Workstream__c = workstream1.Id;
        workstreamCase1.Case__c = case1.Id;
        insert workstreamCase1; 

        new WorkstreamCase_RedirectToManage(new ApexPages.StandardController(workstreamCase1)).redirect();
    }
}