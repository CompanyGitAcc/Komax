tableextension 59064 "TP Cust. Ledger Entry" extends "Cust. Ledger Entry"
{

    fields
    {
        // field(50000; "Jinsui Invoice No."; Code[20])
        // {
        //     Caption = 'Jinsui Invoice No.';
        // }
        //++Deposit
        field(60001; "Order No."; Code[500])
        {
            Caption = 'Order No.';
            DataClassification = ToBeClassified;
            trigger OnLookup()
            var
                SalesHeader: Record "Sales Header";
                SalesOrders: Page "Sales Order List";
            begin
                SalesHeader.setrange("Sell-to Customer No.", Rec."Customer No.");
                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                SalesOrders.SetTableView(SalesHeader);
                if SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Order No.") then
                    SalesOrders.SetRecord(SalesHeader);

                SalesOrders.LookupMode := true;
                if SalesOrders.RunModal = ACTION::LookupOK then begin
                    SalesOrders.GetRecord(SalesHeader);
                    Rec."Order No." := SalesHeader."No.";
                end;
            end;

            trigger OnValidate()
            var
                DtlCustLedgerEntry: Record "Detailed Cust. Ledg. Entry";
            begin
                DtlCustLedgerEntry.Reset();
                DtlCustLedgerEntry.SetRange("Cust. Ledger Entry No.", Rec."Entry No.");
                if DtlCustLedgerEntry.FindFirst() then
                    repeat
                        DtlCustLedgerEntry."Order No." := Rec."Order No.";
                        DtlCustLedgerEntry.SetRange("Entry Type", DtlCustLedgerEntry."Entry Type"::"Initial Entry");
                        DtlCustLedgerEntry.Modify();
                    until DtlCustLedgerEntry.Next() = 0;
            end;
        }
        field(60002; "Advance Payment"; Boolean)
        {
            Caption = 'Advance Payment';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                DtlCustLedgerEntry: Record "Detailed Cust. Ledg. Entry";
            begin
                DtlCustLedgerEntry.Reset();
                DtlCustLedgerEntry.SetRange("Cust. Ledger Entry No.", Rec."Entry No.");
                DtlCustLedgerEntry.SetRange("Entry Type", DtlCustLedgerEntry."Entry Type"::"Initial Entry");
                if DtlCustLedgerEntry.FindFirst() then
                    repeat
                        DtlCustLedgerEntry."Advance Payment" := Rec."Advance Payment";
                        DtlCustLedgerEntry.Modify();
                    until DtlCustLedgerEntry.Next() = 0;
            end;
        }
        //--Deposit
        field(60003; "JinShui Inv. No."; Code[100])
        {
            Caption = 'JinShui Inv. No.';
            DataClassification = ToBeClassified;
        }
        field(60004; "Customer Name 2"; Text[50])
        {
            Caption = 'Customer Name 2';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Name 2" WHERE("No." = FIELD("Customer No.")));
        }
        field(60005; "Sales Person"; Code[20])
        {
            Caption = 'Sales Person';
            DataClassification = ToBeClassified;
        }
        field(60006; "Order Type"; Enum "Sales Order Type")
        {
            Caption = 'Order Type';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Order Type" where("No." = field("Order No.")));
        }
    }
}
