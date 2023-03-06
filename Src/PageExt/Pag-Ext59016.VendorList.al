pageextension 59016 "TP Vendor List" extends "Vendor List"
{
    layout
    {
        addafter("Name 2")
        {
            field("Short Name"; Rec."Short Name")
            {
                ApplicationArea = all;
            }
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        addafter("Search Name")
        {
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                Caption = 'Created At';
            }
        }
        modify("Payment Terms Code")
        {
            Visible = true;
        }
    }
    actions
    {
        addlast("Ven&dor")
        {
            action("Refresh Default Bank")
            {
                Caption = 'Autofill Prefer Bank';
                Image = Refresh;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    VendBankAcc: Record "Vendor Bank Account";
                    Vendor: Record Vendor;
                begin
                    Vendor.Reset();
                    Vendor.setrange("Preferred Bank Account Code", '');
                    if Vendor.FindFirst() then
                        repeat
                            VendBankAcc.reset;
                            VendBankAcc.SetRange("Vendor No.", Vendor."No.");
                            if VendBankAcc.FindFirst() then begin
                                Vendor."Preferred Bank Account Code" := VendBankAcc.Code;
                                Vendor.Modify()
                            end;
                        until Vendor.Next() = 0;
                end;
            }
        }
    }
}
