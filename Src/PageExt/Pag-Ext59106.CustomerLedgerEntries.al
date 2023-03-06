pageextension 59106 "TP Customer Ledger Entries" extends "Customer Ledger Entries"
{

    layout
    {

        modify("External Document No.")
        {
            Visible = true;
        }
        addafter(Description)
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = all;
                trigger OnDrillDown()
                var
                    SalesOrder: page "Sales Order";
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.SetFilter("No.", Rec."Order No.");
                    SalesOrder.SetTableView(SalesHeader);
                    SalesOrder.Run();
                    Clear(SalesOrder);
                end;
            }
        }
        moveafter("Order No."; "External Document No.")

        modify(RecipientBankAccount)
        {
            Visible = false;
        }
        modify("Message to Recipient")
        {
            Visible = false;
        }
        modify("Exported to Payment File")
        {
            Visible = false;
        }
        modify("Original Pmt. Disc. Possible")
        {
            Visible = false;
        }
        modify("Remaining Pmt. Disc. Possible")
        {
            Visible = false;
        }
        modify("Max. Payment Tolerance")
        {
            Visible = false;
        }

        modify("Customer Name")
        {
            Visible = true;
        }
        addafter(Description)
        {
            field("Advance Payment"; Rec."Advance Payment") { ApplicationArea = all; }
        }
        addafter("Customer Name")
        {
            field("Customer Name 2"; Rec."Customer Name 2")
            {
                ApplicationArea = all;
            }
        }
        addafter("Customer No.")
        {
            field("Sales Person"; Rec."Sales Person")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        modify("Salesperson Code")
        {
            Visible = false;
        }
        addafter(Description)
        {
            field(SystemCreatedBy; TPUtilities.GetCreatedByName(Rec.SystemCreatedBy))
            {
                Caption = 'Created By';
            }
        }
    }

    actions
    {
        addlast("F&unctions")
        {
            action("Accept")
            {
                Caption = 'Accept';
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    CustLedgerEntry: Record "Cust. Ledger Entry";
                begin
                    CurrPage.SetSelectionFilter(CustLedgerEntry);
                    if CustLedgerEntry.FindFirst() then
                        CustLedgerEntry.MODIFYALL("Advance Payment", TRUE);
                    CurrPage.Update();
                end;
            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        if Rec."User ID" <> 'KOMAX\CN101252' then begin
            if SalesHeader.get(SalesHeader."Document Type"::Order, Rec."Order No.") then begin
                Rec."Sales Person" := SalesHeader."SalesPerson Code";
                Rec."Order Type" := SalesHeader."Order Type";
            end else begin
                Rec."Sales Person" := '';
                Rec."Order Type" := Rec."Order Type"::" ";
            end;
        end else begin
            if SalesHeader.get(SalesHeader."Document Type"::Order, Rec."Order No.") then begin
                Rec."Order Type" := SalesHeader."Order Type";
            end else begin
                Rec."Order Type" := Rec."Order Type"::" ";
            end;
        end;
    end;

    var
        SalesHeader: Record "Sales Header";
        SalesPerson: Code[20];
        OrderType: Enum "Sales Order Type";
        TPUtilities: Codeunit "TP Utilities";

}
