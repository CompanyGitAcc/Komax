pageextension 59013 "TP Customer List" extends "Customer List"
{
    layout
    {

        addafter(Name)
        {
            field("Short Name"; Rec."Short Name")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = all;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
            }
            field(BankName; BankName)
            {
                ApplicationArea = all;
            }
            field(BankAccount; BankAccount)
            {
                ApplicationArea = all;
            }
            field("Sales Person"; Rec."Salesperson Code")
            {
                ApplicationArea = all;
            }
            field("Service Person"; Rec."Service Person")
            {
                ApplicationArea = all;
            }
            field(Segementation; Rec.Segementation)
            {
                ApplicationArea = all;
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                Caption = 'Created At';
            }
        }
    }
    actions
    {
        addlast("&Customer")
        {
            action("Refresh Default Bank")
            {
                Caption = 'Autofill Prefer Bank';
                Image = Refresh;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CustBankAcc: Record "Customer Bank Account";
                    customer: Record Customer;
                begin
                    customer.Reset();
                    customer.setrange("Preferred Bank Account Code", '');
                    if customer.FindFirst() then
                        repeat
                            CustBankAcc.reset;
                            CustBankAcc.SetRange("Customer No.", customer."No.");
                            if CustBankAcc.FindFirst() then begin
                                customer."Preferred Bank Account Code" := CustBankAcc.Code;
                                customer.Modify()
                            end;
                        until customer.Next() = 0;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        CustBankAcc: Record "Customer Bank Account";
    begin
        BankName := '';
        if CustBankAcc.Get(Rec."No.", Rec."Preferred Bank Account Code") then begin
            BankName := CustBankAcc.Name;
            BankAccount := CustBankAcc."Bank Account No.";
        end;


    end;

    var
        BankName: Text[100];
        BankAccount: Text[100];
}