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
            field(SalesPerson; SalesPerson)
            {
                Caption = 'SalesPerson';
                ApplicationArea = all;
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

    trigger OnAfterGetRecord()
    begin
        SalesInvoiceLine.Reset();
        SalesInvoiceLine.SetRange("Document No.", Rec."Document No.");
        if SalesInvoiceLine.FindLast() then begin
            if SalesHeader.get(SalesHeader."Document Type"::Order, SalesInvoiceLine."Order No.") then begin
                SalesPerson := SalesHeader."Sales Person";
            end;
        end;
    end;

    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesHeader: Record "Sales Header";
        SalesPerson: Code[20];
        TPUtilities: Codeunit "TP Utilities";

}
