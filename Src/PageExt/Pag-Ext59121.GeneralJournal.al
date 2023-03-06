pageextension 59121 "TP General Journal" extends "General Journal"
{
    layout
    {
        modify("EU 3-Party Trade")
        {
            Visible = false;
        }
        addafter(Amount)
        {
            field("Advance Payment"; Rec."Advance Payment")
            {
                ApplicationArea = all;
            }
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Account No.")
        {
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = all;
            }
        }
        modify("Applies-to Doc. Type")
        {
            Visible = true;
        }
        modify("Applies-to Doc. No.")
        {
            Visible = true;
        }
    }

    // trigger OnAfterGetRecord()
    // var
    //     Customer: Record Customer;
    //     BankAccount: Record "Bank Account";
    //     Vendor: Record Vendor;
    // begin
    //     CASE Rec."Account Type" OF
    //         Rec."Account Type"::Customer:
    //             if Customer.get(Rec."Account No.") then begin
    //                 AccuontName := Customer."Name 2";
    //             end;
    //         Rec."Account Type"::"Bank Account":
    //             if BankAccount.get(Rec."Account No.") then begin
    //                 AccuontName := BankAccount."Name 2";
    //             end;
    //         Rec."Account Type"::Vendor:
    //             if Vendor.get(Rec."Account No.") then begin
    //                 AccuontName := Vendor."Name 2";
    //             end;
    //     END;
    // END;

    // var
    //     AccuontName: Text[100];

}
