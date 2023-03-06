pageextension 59017 "TP Vendor Card" extends "Vendor Card"
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
        modify("Name 2")
        {
            Visible = true;
            Importance = Promoted;
        }
        modify("Purchaser Code")
        {
            ShowMandatory = true;
        }
        modify("Responsibility Center")
        {
            ShowMandatory = true;
        }
        modify(Address)
        {
            ShowMandatory = true;
        }
        modify("Country/Region Code")
        {
            ShowMandatory = true;
        }
        modify(MobilePhoneNo)
        {
            ShowMandatory = true;
        }
        modify("E-Mail")
        {
            ShowMandatory = true;
        }
        modify("Language Code")
        {
            ShowMandatory = true;
        }
        // modify("Currency Code")
        // {
        //     ShowMandatory = true;
        // }
        modify("Shipment Method Code")
        {
            ShowMandatory = true;
        }
    }

    actions
    {
        moveafter("F&unctions"; OrderAddresses)
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Rec.TestField("Purchaser Code");
        Rec.TestField("Responsibility Center");
        Rec.TestField(Address);
        Rec.TestField("Country/Region Code");
        Rec.TestField("Mobile Phone No.");
        Rec.TestField("E-Mail");
        Rec.TestField("Language Code");
        // Rec.TestField("Currency Code");
        Rec.TestField("Shipment Method Code");
    end;
}
