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
private with sharing class Task_SetStatusInProgressTest {
    public static testmethod void testTrigger() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Story__c story1 = new Story__c();
        story1.Name = 'Story';
        story1.Sprint__c = sprint1.Id;
        story1.Workstream__c = workstream1.Id;
        insert story1;

        Task__c task1 = new Task__c();
        task1.Name = 'Task';
        task1.Sprint__c = sprint1.Id;
        task1.Story__c = story1.Id;
        insert task1;
        
        system.assertEquals('Not Yet Started', [
            select TaskStatus__c
              from Story__c
             where Id = :story1.Id
        ].TaskStatus__c);    

        task1.ActualHours__c = 1;
        update task1;
        
        system.assertEquals('In Progress', [
            select TaskStatus__c
              from Story__c
             where Id = :story1.Id
        ].TaskStatus__c);    
    }

}