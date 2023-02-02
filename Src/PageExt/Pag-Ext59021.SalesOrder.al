pageextension 59021 "TP Sales Order" extends "Sales Order"
{

    layout
    {
        moveafter(General; "Invoice Details")
        addafter("Sell-to Contact")
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                Importance = Additional;
            }
        }
        addlast(General)
        {
            //Komax新增字段
            group(komax)
            {
                Caption = 'Komax Extension';
                field("Sales Person"; Rec."Sales Person")
                {
                    ApplicationArea = all;
                }
                field("Service Person"; Rec."Service Person")
                {
                    ApplicationArea = all;
                }
                field("Order Type"; Rec."Order Type")
                {
                    ApplicationArea = all;
                    ShowMandatory = true;
                    //Importance = Additional;
                }
                field("Machine Model"; Rec."Machine Model")
                {
                    ShowMandatory = true;
                    //Importance = Promoted;
                    ApplicationArea = all;
                }
                field("Posting No. Series"; Rec."Posting No. Series")
                {
                    ShowMandatory = true;
                    Importance = Promoted;
                    ApplicationArea = all;
                }
                field("Last Date Released"; Rec."Last Date Released")
                {
                    ApplicationArea = all;
                }
                field("Last Time Released"; Rec."Last Time Released")
                {
                    Importance = Additional;
                    ApplicationArea = all;
                }
                field("Print Flag"; Rec."Print Flag")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Importance = Additional;
                }
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = all;
                }
            }
            field(SystemCreatedBy; TPUtilities.GetCreatedByName(Rec.SystemCreatedBy))
            {
                Caption = 'Created By';
                Importance = Additional;
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                Caption = 'Created At';
                Importance = Additional;
            }
        }
        modify("Responsibility Center") { Visible = false; }
        modify("Campaign No.") { Visible = false; }
        modify("Opportunity No.") { Visible = false; }
        modify("Foreign Trade")
        {
            Visible = false;
        }
        modify("Sell-to Customer Name")
        {
            ShowMandatory = true;
            Importance = Promoted;
        }
        modify("Sell-to Customer No.")
        {
            ShowMandatory = true;
            Importance = Promoted;
        }
        modify("Shortcut Dimension 1 Code")
        {
            ShowMandatory = true;
            Importance = Promoted;
        }
        modify("Document Date")
        {
            Importance = Promoted;
        }

        modify("VAT Bus. Posting Group")
        {
            ShowMandatory = true;
            Importance = Promoted;
        }

        //Invoice-------------------------------------------------------
        modify("EU 3-Party Trade") { Visible = false; }
        modify(Control76) { Visible = false; } //Payment services
        modify("Direct Debit Mandate ID") { Visible = false; }
        modify("Payment Discount %") { Visible = false; }
        modify("Pmt. Discount Date") { Visible = false; }
        modify(Control1900201301) { Visible = false; } //Hide prepayment

        //++BC190.Deposit1.00
        addafter("Payment Terms Code")
        {
            field("Advance Payment %"; Rec."Advance Payment %") { ApplicationArea = all; }
            field("Advance Payment Received"; Rec."Advance Payment Received")
            {
                ApplicationArea = all;
                trigger OnDrillDown()
                var
                    custLedgerEntry: Record "Cust. Ledger Entry";
                    CustLedgerEntryPage: Page "Customer Ledger Entries";
                begin
                    CustLedgerEntry.SetRange("Order No.", Rec."No.");
                    CustLedgerEntryPage.SetTableView(custLedgerEntry);
                    CustLedgerEntryPage.RunModal();
                end;
            }
        }
        //--BC190.Deposit1.00
        addlast("Invoice Details")
        {
            // field("Jinsui Invoice No.s"; Rec."Jinsui Invoice No.s")
            // {
            //     ApplicationArea = all;
            // }
            // field("Navision Phantom Invoice No.s"; Rec."Navision Phantom Invoice No.s")
            // {
            //     ApplicationArea = all;
            // }
            // field("Cancelled Invoice No.s"; Rec."Cancelled Invoice No.s")
            // {
            //     ApplicationArea = all;
            // }
            // field("Everything Is Invoiced"; Rec."Everything Is Invoiced")
            // {
            //     ApplicationArea = all;
            // }

            field("Partial Shiped"; Rec."Partial Shiped")
            {
                ApplicationArea = all;
            }
            group(Komax2)
            {
                Caption = 'Komax Extension';
                field("Bill-to Department"; Rec."Bill-to Department")
                {
                    ApplicationArea = all;
                }
                field("Bill to Contact Phone No"; Rec."Bill to Contact Phone No")
                {
                    ApplicationArea = all;
                }
                field("Outstanding Amount"; Rec."Outstanding Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Material Shipped not Invoiced"; Rec."Material Shipped not Invoiced")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Quotes Line Discount"; Rec."Quotes Line Discount")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Total Line Amount"; Rec."Total Line Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }

        modify("Posting Description")
        {
            Visible = true;
            Importance = Additional;
        }
        modify("Due Date")
        {
            Importance = Additional;
        }
        modify("Sell-to Contact")
        {
            Importance = Additional;
        }
        modify("Sell-to City")
        {
            Importance = Promoted;
        }

        addafter("Ship-to Name")
        {
            field("Ship-to Name 2"; Rec."Ship-to Name 2")
            {
                ApplicationArea = all;
            }
            field("Ship To Phone No"; Rec."Ship-to Phone No.")
            {
                ApplicationArea = all;
            }
        }

        addafter("Sell-to Customer Name")
        {
            field("Sell-to Customer Name 2"; Rec."Sell-to Customer Name 2")
            {
                ApplicationArea = all;
            }
        }
        modify("Salesperson Code")
        {
            Importance = Promoted;
        }
        modify("Your Reference")
        {
            Importance = Promoted;
        }
        moveafter("Order Date"; "Document Date")
        moveafter("External Document No."; "Salesperson Code")
        moveafter("Machine Model"; "Your Reference")
        moveafter("Your Reference"; "Posting No. Series")
        addafter("Your Reference")
        {
            field("Everything Is Invoiced"; Rec."Everything Is Invoiced")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Posting No. Series"; Status)
        modify("No.")
        {
            Visible = true;
        }
        movebefore("Sell-to Customer No."; "No.")
    }
    actions
    {
        modify("Create &Warehouse Shipment")
        {
            Promoted = true;
            PromotedCategory = Process;
        }
        modify("Create Inventor&y Put-away/Pick")
        {
            Promoted = false;
        }
        //++BC190.Depost1.00.ALF
        addafter("&Order Confirmation")
        {
            action("Receive Deposit")
            {
                Caption = 'Receive Payment';
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    CreatePayment: Page "Create Deposit Payment";
                begin
                    Rec.TestField(Status, Rec.Status::Released);
                    CreatePayment.SetValue(Rec."No.", 1);
                    IF CreatePayment.RUNMODAL = ACTION::OK THEN BEGIN
                        CreatePayment.PostDepositJournal;
                        CLEAR(CreatePayment);
                    END ELSE
                        CLEAR(CreatePayment);
                end;
            }
            action("Return Deposit")
            {
                Caption = 'Return Payment';
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    CreatePayment: Page "Create Deposit Payment";
                begin
                    CreatePayment.SetValue(Rec."No.", 2);
                    Rec.TestField(Status, Rec.Status::Released);
                    IF CreatePayment.RUNMODAL = ACTION::OK THEN BEGIN
                        CreatePayment.PostDepositJournal;
                        CLEAR(CreatePayment);
                    END ELSE
                        CLEAR(CreatePayment);
                end;
            }

        }
        //--BC190.Depost1.00.ALF

        addafter("&Print")
        {
            action("Order Confirmation English")
            {
                Caption = 'Order Confirmation English';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category11;

                trigger OnAction()
                var
                    ENSalesOrder: Report "EN Sales Order";
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.SetRange("Document Type", Rec."Document Type"::Order);
                    SalesHeader.SetRange("No.", Rec."No.");
                    ENSalesOrder.SetTableView(SalesHeader);
                    ENSalesOrder.RunModal();
                end;
            }
            action("Print Sales Order In Chinese")
            {
                Caption = 'Print Sales Order In Chinese';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category11;

                trigger OnAction()
                var
                    CNSalesOrder: Report "CN Sales Order";
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.SetRange("Document Type", Rec."Document Type"::Order);
                    SalesHeader.SetRange("No.", Rec."No.");
                    CNSalesOrder.SetTableView(SalesHeader);
                    CNSalesOrder.RunModal();
                end;
            }
        }
    }

    var
        TPUtilities: Codeunit "TP Utilities";
}
