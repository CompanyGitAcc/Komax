pageextension 59094 "TP Posted Whse. Receipt" extends "Posted Whse. Receipt"
{
    layout
    {
        addlast(General)
        {
            field(SystemCreatedBy; TPUtilities.GetCreatedByName(Rec.SystemCreatedBy))
            {
                Caption = 'Created By';
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                Caption = 'Created At';
            }
        }

        addlast(content)
        {
            group("Buy-from")
            {
                Caption = 'Buy-from';
                field("Buy-from Type"; Rec."Buy-from Type")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Buy-from No."; Rec."Buy-from No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Name; Rec."Buy-from Name")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                // field("Ship-to Address Code"; Rec."Buy-from Address Code")
                // {
                //     Editable = false;
                //     ApplicationArea = all;
                // }
                // field(Address; Rec."Buy-from Address")
                // {
                //     Editable = false;
                //     ApplicationArea = all;
                // }
                // field("Phone No."; Rec."Buy-from Phone No.")
                // {
                //     Editable = false;
                //     ApplicationArea = all;
                // }
                // field(Contact; Rec."Buy-from Contact")
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
        TPUtilities: Codeunit "TP Utilities";
}
