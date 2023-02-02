pageextension 59087 "TP Posted Whse. Shipment" extends "Posted Whse. Shipment"
{
    layout
    {
        addlast(General)
        {

            field(PrintCount; PrintCount)
            {
                Editable = false;
                ApplicationArea = all;
            }
            field(SystemCreatedBy; TPUtilities.GetCreatedByName(Rec.SystemCreatedBy))
            {
                Caption = 'Created By';
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                Caption = 'Created At';
            }
            field(Remark; Rec.Remark)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter(Shipping)
        {
            group(Customer)
            {
                Caption = 'Customer';
                // field("Ship-to Type"; Rec."Ship-to Type")
                // {
                //     Editable = false;
                //     ApplicationArea = all;
                // }
                // field("Customer No."; Rec."Ship-to No.")
                // {
                //     Editable = false;
                //     ApplicationArea = all;
                // }
                // field(Name; Rec."Ship-to Name")
                // {
                //     Editable = false;
                //     ApplicationArea = all;
                // }
                // field("Ship-to Address"; Rec."Ship-to Address Code")
                // {
                //     Editable = false;
                //     ApplicationArea = all;
                // }
                // field(Address; Rec."Ship-to Address")
                // {
                //     Editable = false;
                //     ApplicationArea = all;
                // }
                // field("Phone No."; Rec."Ship-to Phone No.")
                // {
                //     Editable = false;
                //     ApplicationArea = all;
                // }
                // field(Contact; Rec."Ship-to Contact")
                // {
                //     Editable = false;
                //     ApplicationArea = all;
                // }
            }
        }
    }

    actions
    {
        addafter("&Print")
        {


        }
    }

    var
        PrintCount: Integer;
        TPUtilities: Codeunit "TP Utilities";
}
