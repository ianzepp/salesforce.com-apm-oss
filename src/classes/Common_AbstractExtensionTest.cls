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
private with sharing class Common_AbstractExtensionTest {
    public class Common_AbstractExtensionConcrete extends Common_AbstractExtension {
        public Common_AbstractExtensionConcrete(ApexPages.StandardController controller) {
            super(controller);
        }
    }
    
    public class Common_AbstractExtensionException extends Exception {}

    public static testmethod void testGenerateCodeCoverage() {
        ApexPages.StandardController apexController = new ApexPages.StandardController(new Account());
        Common_AbstractExtensionConcrete commonController = new Common_AbstractExtensionConcrete(apexController);
        commonController.getControllerId();
        commonController.getControllerRecord();
        commonController.getPageParameters();
        commonController.getPageParam('none');
        commonController.addMessage('none');
        commonController.addMessage(ApexPages.Severity.INFO, 'none');
        commonController.addExceptionMessage(new Common_AbstractExtensionException());
        commonController.addChangesSavedMessage();
        commonController.getMessageList();
        commonController.getMessageListSize();
        commonController.getMessageListSize(ApexPages.Severity.ERROR);
    }
}