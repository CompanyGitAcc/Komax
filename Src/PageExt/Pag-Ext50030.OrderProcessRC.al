pageextension 50030 "TP Order Processor Role Center" extends "Order Processor Role Center"
{
    layout
    {
        //===========================================Cube and Chart========================================    
        //hide: team member
        modify(Control14) { Visible = false; }
        addlast(rolecenter)
        {
        }
    }

    actions
    {
        //#==========================================Embedding=============================================
        modify("Sales Journals") { Visible = false; }
        modify(CashReceiptJournals) { Visible = false; }
        modify(Customer) { Visible = false; }
        //===========================================Main Menus============================================
        modify("Sales Orders - Microsoft Dynamics 365 Sales") { Visible = false; }
        modify("Sales Invoices") { Visible = false; }
        modify("Sales Credit Memos") { Visible = false; }
        modify("Posted Sales Invoices") { Visible = false; }
        modify("Posted Sales Credit Memos") { Visible = false; }
        modify(Reminders) { Visible = false; }
        modify("Finance Charge Memos") { Visible = false; }
        modify("Purchase Invoices") { Visible = false; }
        modify("Purchase Credit Memos") { Visible = false; }
        modify(PurchaseJournals) { Visible = false; }
        modify("Posted Purchase Invoices") { Visible = false; }
        modify("Posted Purchase Credit Memos") { Visible = false; }
        //posted invoice/credit memos
        modify(Action34) { Visible = false; }
        modify(Action54) { Visible = false; }
        modify(Action86) { Visible = false; }
        modify("Issued Reminders") { Visible = false; }
        modify("Issued Finance Charge Memos") { Visible = false; }
        modify(SetupAndExtensions) { Visible = false; }
        //New Group - Master Data
        addbefore(Action76)
        {
            group(Data)
            {
                Caption = 'Master Data';
                action(ProductionBOM)
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Production BOM';
                    Image = BOM;
                    RunObject = Page "Production BOM List";
                }
                action(ProductionBOMLine)
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Production BOM Line';
                    Image = BOM;
                    RunObject = Page "Prod. BOM Lines";
                }
                action(Routings)
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Routings';
                    Image = Route;
                    RunObject = Page "Routing List";
                }
                action(WorkCenters)
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Work Centers';
                    Image = WorkCenter;
                    RunObject = Page "Work Center List";
                }
                action("Machine Centers")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Machine Centers';
                    Image = MachineCenter;
                    RunObject = Page "Machine Center List";
                }
                action(Resource)
                {
                    ApplicationArea = all;
                    Caption = 'Resource';
                    RunObject = Page "Resource List";
                    Visible = false;
                }


                action("ECN Record")
                {
                    ApplicationArea = all;
                    Caption = 'ECN Record';
                    RunObject = Page "ECN Record";
                }
            }
        }
        movefirst(data; Items, "Item Charges", Locations)
        //Sales:Add Purchase Requests/Line Group

        addlast(Action76)
        {
            action("TP Cust Statistics Report")
            {
                ApplicationArea = Basic, Suite;
                Image = Report;
                Caption = 'Cust Statistics Report';
                RunObject = Page "TP Cust Statistics Report";
            }
            group("Sales Lines")
            {
                Caption = 'Lines';
                action("Sales Order Lines")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Order Lines';
                    RunObject = Page "TP Sales Lines";
                    //RunPageView = where("OrderStatus" = const(Released));
                }
                action("Sales Shipment Lines")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Shipment Lines';
                    RunObject = Page "Sales Shipment Lines";
                }

            }
        }
        addafter("Sales Orders")
        {
            action("Sales Invoice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Invoice';
                RunObject = Page "Sales Invoice List";
            }
        }
        //Purchases: add Lines Group
        addlast(Action63)
        {
            action("PPI With Vendor")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'PPI With Vendor';
                RunObject = Page "PPI With Vendor";
            }
            group("Purchase Lines")
            {
                Caption = 'Lines';

                action("Blanket Purchase Order Lines")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Blanket Purch. Order Lines';
                    RunObject = Page "Blanket Purch. Lines";
                }

                action("Purchase Order Lines")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Purchase Order Lines';
                    RunObject = Page "TP Purchase Order Lines";
                }
                action("Purchase Receipt Lines")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Purchase Receipt Lines';
                    RunObject = Page "TP Purch. Receipt Lines";
                }

            }
        }
        //Group - Inventory
        moveafter("Phys. Inventory Journals"; "Transfer Orders")
        addafter(Items)
        {
        }
        addafter("Assembly Orders")
        {
        }
        addafter("Purchase Orders")
        {
            action("Purchase Invoice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Invoices';
                RunObject = Page "Purchase Invoices";
            }
        }
        //New Group - Warehouse
        addafter(Action62)
        {
            group(Warehouse)
            {
                Caption = 'Warehouse';
                action("Warehouse Receipts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Warehouse Receipts';
                    RunObject = Page "Warehouse Receipts";
                }
                action("Warehouse Shipments")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Warehouse Shipments';
                    RunObject = Page "Warehouse Shipment List";
                }
                action("Warehouse Putaway")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Warehouse Put-aways';
                    RunObject = Page "Warehouse Put-aways";
                }
                action("Warehouse Picks")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Warehouse Picks';
                    RunObject = Page "Warehouse Picks";
                }
                action("Warehouse Movements")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Warehouse Movements';
                    RunObject = Page "Warehouse Movements";
                }
                action("Physical Inventory Orders")
                {
                    ApplicationArea = all;
                    Caption = 'Physical Inventory Orders';
                    RunObject = Page "Physical Inventory Orders";
                }

                action("Bin Content")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bin Content';
                    RunObject = Page "Bin Contents";
                }

            }

            group("Production")
            {
                Caption = 'Production';
                action("Simulated Production Orders")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Simulated Production Orders';
                    RunObject = Page "Simulated Production Orders";
                    Visible = false;
                }
                action("Planned Production Orders")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Planned Production Orders';
                    RunObject = Page "Planned Production Orders";
                    Visible = false;
                }
                action("Firm Planned Production Orders")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Firm Planned Production Orders';
                    RunObject = Page "Firm Planned Prod. Orders";
                    Visible = false;
                }
                action("Released Production Orders")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Released Production Orders';
                    RunObject = Page "Released Production Orders";
                }
                action(ConsumptionJournals)
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Consumption Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Consumption),
                                        Recurring = CONST(false));
                }
                action(OutputJournals)
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Output Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Output),
                                        Recurring = CONST(false));
                }
                action(CapacityJournals)
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Capacity Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Capacity),
                                        Recurring = CONST(false));
                }
                action("Firm Planned Prod. Orders")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Firm Planned Prod. Orders';
                    RunObject = Page "Firm Planned Prod. Orders";
                }

            }

        }
        //Posted Documents
        modify("Sales Order Archive") { Visible = false; }
        modify("Sales Quote Archive") { Visible = false; }
        modify("Sales Return Order Archives") { Visible = false; }
        modify("Blanket Sales Order Archives") { Visible = false; }
        //modify("Posted Sales Credit Memos") { Visible = false; }
        //modify("Posted Sales Invoices") { Visible = false; }
        modify("Posted Sales Return Receipts") { Visible = false; }
        addlast("Posted Documents")
        {

            action("Item Ledger Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Ledger Entries';
                Image = LedgerEntries;
                RunObject = Page "Item Ledger Entries";
            }
            action("Warehouise Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouise Entries';
                Image = LedgerEntries;
                RunObject = Page "Warehouse Entries";
            }
            group("Posted Docs")
            {
                Caption = 'Posted Documents';
                action("Finished Production Orders")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Finished Production Orders';
                    RunObject = Page "Finished Production Orders";
                }
            }
            group("Posted Whse. Document")
            {
                Caption = 'Posted Warehouse Documents';
                action("Warehouse Receipt Lines")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Warehouse Receipt Lines';
                    RunObject = Page "MP Whse. Receipt Lines";
                }
                action("Warehouse Shipment Lines")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Warehouse Shipment Lines';
                    RunObject = Page "MP Whse. Shipment Lines";
                }
                action("Posted Warehouse Receipts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Warehouse Receipts';
                    RunObject = Page "Posted Whse. Receipt List";
                }
                action("Registered Warehouse Shipments")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Registered Warehouse Shipments';
                    RunObject = Page "Posted Whse. Shipment List";
                }
            }
        }
        // movefirst("Posted Docs"; "Posted Sales Shipments", "Posted Return Receipts", "Posted Purchase Receipts", "Posted Purchase Return Shipments", "Posted Transfer Shipments", "Posted Transfer Receipts")
        movefirst("Posted Docs"; "Posted Return Receipts", "Posted Purchase Return Shipments", "Posted Transfer Shipments", "Posted Transfer Receipts")
        //===========================================Actions===============================================
        modify("Sales &Invoice") { Visible = false; }
        modify("Sales &Credit Memo") { Visible = false; }
        modify("Sales &Journal") { Visible = false; }
        modify("Sales Price &Worksheet") { Visible = false; }
        modify("&Prices") { Visible = false; }
        modify("&Line Discounts") { Visible = false; }

        addbefore(Tasks)
        {
            group("Setup")
            {
                Caption = 'Setup';
                action("Item Categories")
                {
                    ApplicationArea = all;
                    Caption = 'Item Categories';
                    Image = List;
                    RunObject = Page "Item Categories";
                }
                action("Item Template")
                {
                    ApplicationArea = all;
                    Caption = 'Item Template';
                    Image = List;
                    RunObject = Page "Item Templ. List";
                }

                action("Warehouse Employee")
                {
                    ApplicationArea = all;
                    Caption = 'Warehouse Employees';
                    Image = List;
                    RunObject = Page "Warehouse Employees";
                }

                action("Production Group Mapping")
                {
                    ApplicationArea = all;
                    Image = List;
                    Caption = 'Production Group Mapping';
                    RunObject = Page "Product Group Mapping";
                }
                action("Inventory Group Mapping")
                {
                    ApplicationArea = all;
                    Image = List;
                    Caption = 'Inventory Group Mapping';
                    RunObject = Page "Inventory Group Mapping";
                }
                action("Reservation Entries")
                {
                    ApplicationArea = all;
                    Image = List;
                    Caption = 'Reservation Entries';
                    RunObject = Page "Edit Reservation Entries";
                }

                // action("Shipping Agents")
                // {
                //     ApplicationArea = all;
                //     Caption = 'Shipping Agents';
                //     RunObject = Page "Shipping Agents";
                // }
            }
            group(Worksheets)
            {
                Caption = 'Worksheets';
                action("Put-away Worksheet")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Put-away Worksheet';
                    Image = Planning;
                    RunObject = page "Put-away Worksheet";
                }
                action("Pick Worksheet")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Pick Worksheet';
                    Image = Planning;
                    RunObject = page "Pick Worksheet";
                }
                action("Requisition Worksheet")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Requisition Worksheet';
                    Image = Planning;
                    RunObject = page "Req. Worksheet";
                }
                action("Planning Worksheet")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Planning Worksheet';
                    Image = PlanningWorksheet;
                    RunObject = Page "Planning Worksheet";
                }
                action("Movement Worksheet")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Movement Worksheet';
                    Image = Planning;
                    RunObject = Page "Movement Worksheet";
                }
            }
        }
        //moveafter("Item Categories"; "Item Attributes")

        addlast(Reports)
        {
            action("Item Requisite Report")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Requisite Report';
                Image = Report;
                RunObject = Page "Item Requisite Report";
            }

        }
        addlast(Tasks)
        {
            action("Configuration Package")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Configuration Package';
                RunObject = Page "Config. Packages";
                Visible = false;
            }
        }
    }
}
