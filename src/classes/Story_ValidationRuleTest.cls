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
private with sharing class Story_ValidationRuleTest {
    public static testmethod void testIsInProgressWithoutTasks() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
        Sprint__c sprint = new Sprint__c();
        sprint.Name = 'Sprint';
        sprint.StartsOn__c = Date.today();
        sprint.CompletesOn__c = Date.today().addDays(1);
        sprint.Workstream__c = workstream1.Id;
        insert sprint;

        Story__c story = new Story__c();
        story.Name = 'Story';
        story.Sprint__c = sprint.Id;
        story.TaskStatus__c = 'In Progress';
        story.Workstream__c = workstream1.Id;

/*      try {
            insert story;
            system.assertEquals('In Progress',[
                select TaskStatus__c
                  from Story__c
                 where Id = :story.Id
            ].TaskStatus__c);
            system.assert(false, 'Validation rule test failure');
        } catch (System.DmlException e) {
            system.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, e.getDmlType(0));
            system.assertEquals(e.getDmlMessage(0), 'Task Status cannot be In Progress or Blocked if Total Tasks is equal to zero.');
        } */
    }

    public static testmethod void testIsUpdateWhenApprovalCompleted() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
        Sprint__c sprint = new Sprint__c();
        sprint.Name = 'Sprint';
        sprint.StartsOn__c = Date.today();
        sprint.CompletesOn__c = Date.today().addDays(1);
        sprint.Workstream__c = workstream1.Id;
        insert sprint;

        Story__c story = new Story__c();
        story.Name = 'Story';
        story.Sprint__c = sprint.Id;
        story.Workstream__c = workstream1.Id;
        insert story;

        Task__c task = new Task__c();
        task.EstimatedHours__c = 1;
        task.ActualHours__c = 1;
        task.Status__c = 'Completed';
        task.Sprint__c = sprint.Id;
        task.Story__c = story.Id;
        insert task;
        
        system.assertEquals('Completed', [
            select TaskStatus__c
              from Story__c
             where Id = :story.Id
        ].TaskStatus__c);

        story.ApprovalStatus__c = 'Completed';
        update story;

        try {
            story.Name = 'Updated Name';
            update story;
            system.assert(false, 'Validation rule test failure');
        } catch (System.DmlException e) {
            system.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, e.getDmlType(0));
            system.assertEquals(e.getDmlMessage(0), 'Cannot update a Story once the Approval Status is Completed.');
        }
    }

    public static testmethod void testIsUpdateWhenApprovalInProgress() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
        Sprint__c sprint = new Sprint__c();
        sprint.Name = 'Sprint';
        sprint.StartsOn__c = Date.today();
        sprint.CompletesOn__c = Date.today().addDays(1);
        sprint.Workstream__c = workstream1.Id;
        insert sprint;

        Story__c story = new Story__c();
        story.Name = 'Story';
        story.Sprint__c = sprint.Id;
        story.Workstream__c = workstream1.Id;
        insert story;

        Task__c task = new Task__c();
        task.EstimatedHours__c = 1;
        task.ActualHours__c = 1;
        task.Status__c = 'Completed';
        task.Sprint__c = sprint.Id;
        task.Story__c = story.Id;
        insert task;
        
        system.assertEquals('Completed', [
            select TaskStatus__c
              from Story__c
             where Id = :story.Id
        ].TaskStatus__c);

        story.ApprovalStatus__c = 'In Progress';
        update story;

        try {
            story.Name = 'Updated Name';
            update story;
            system.assert(false, 'Validation rule test failure');
        } catch (System.DmlException e) {
            system.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, e.getDmlType(0));
            system.assertEquals(e.getDmlMessage(0), 'Cannot update a Story once the Approval Status is In Progress.');
        }
    }

    public static testmethod void testIsUpdateWhenSprintIsCompleted() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
        Sprint__c sprint = new Sprint__c();
        sprint.Name = 'Sprint';
        sprint.StartsOn__c = Date.today() - 10;
        sprint.CompletesOn__c = Date.today() - 5;
        sprint.Workstream__c = workstream1.Id;
        insert sprint;

        system.assertEquals('Completed', [
            select Status__c
              from Sprint__c
             where Id = :sprint.Id
        ].Status__c);

        Story__c story = new Story__c();
        story.Name = 'Story';
        story.Sprint__c = sprint.Id;
        story.Workstream__c = workstream1.Id;
        
        try {
            insert story;
            system.assert(false, 'Validation rule test failure');
        } catch (System.DmlException e) {
            system.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, e.getDmlType(0));
            system.assertEquals(e.getDmlMessage(0), 'Cannot update a Story once the related Sprint is Completed.');
        }
    }

    public static testmethod void testWorkstreamIsActive() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        workstream1.IsActive__c = true;
        insert workstream1; 
        
        Sprint__c sprint = new Sprint__c();
        sprint.Name = 'Sprint';
        sprint.StartsOn__c = Date.today();
        sprint.CompletesOn__c = Date.today().addDays(1);
        sprint.Workstream__c = workstream1.Id;
        insert sprint;
        
        workstream1.IsActive__c = false;
        update workstream1;

        Story__c story = new Story__c();
        story.Name = 'Story';
        story.Sprint__c = sprint.Id;
        story.Workstream__c = workstream1.Id;
        
        try {
            insert story;
            system.assert(false, 'Validation rule test failure');
        } catch (System.DmlException e) {
            system.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, e.getDmlType(0));
            system.assertEquals(e.getDmlMessage(0), 'Cannot add, remove, or update a Story when the related Workstream exists but is inactive.');
        }
    }

    public static testmethod void testWorkstreamIsNotMissing() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
        Sprint__c sprint = new Sprint__c();
        sprint.Name = 'Sprint';
        sprint.StartsOn__c = Date.today();
        sprint.CompletesOn__c = Date.today().addDays(1);
        sprint.Workstream__c = workstream1.Id;
        insert sprint;
        
        Story__c story = new Story__c();
        story.Name = 'Story';
        story.Sprint__c = sprint.Id;

        // Should pull the workstream from the sprint        
        insert story;
    }
}