/*
 * File: designer.js
 * Date: Tue Sep 06 2011 15:09:45 GMT+0200 (CEST)
 *
 * This file was generated by Ext Designer version 1.2.0.
 * http://www.sencha.com/products/designer/
 *
 * This file will be auto-generated each and everytime you export.
 *
 * Do NOT hand edit this file.
 */

Ext.Loader.setConfig({
    enabled: true
});

Ext.application({
    name: 'NamesApp',

    stores: [
        'NamesStore'
    ],

    launch: function() {
        Ext.QuickTips.init();

        var cmp1 = Ext.create('NamesApp.view.namesWindow', {
            renderTo: Ext.getBody()
        });
        cmp1.show();
    }
});
