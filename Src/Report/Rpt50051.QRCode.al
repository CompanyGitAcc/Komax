report 50051 "QR Code"
{
    // QR1.00
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/EB_QRCode.rdl';

    dataset
    {
        dataitem(WhseActivityHeader; "Warehouse Activity Header")
        {
            RequestFilterFields = "No.", "Assigned User ID", "Assignment Date";
            RequestFilterHeading = 'Warehouse Pick';
            DataItemTableView = where(Type = const(Pick));
            dataitem(WhseActivityLine; "Warehouse Activity Line")
            {
                DataItemLink = "No." = FIELD("No."), "Activity Type" = field(Type);
                DataItemLinkReference = WhseActivityHeader;

                DataItemTableView = SORTING("No.", "Line No.") where("Action Type" = const(Take));
                column(QRcodeImg; EncodedText)
                {
                }
                column(PrintDate; PrintDate)
                {
                }
                column(PrintText1; PrintText1)
                {
                }
                column(PrintText2; PrintText2)
                {
                }
                column(PrintText3; PrintText3)
                {
                }
                column(PrintText4; PrintText4)
                {
                }
                column(PrintText5; PrintText5)
                {
                }
                column(PrintText6; PrintText6)
                {
                }

                trigger OnAfterGetRecord()
                var
                    BarcodeSymbology: Enum "Barcode Symbology 2D";
                    IBarcodeFontProvider: Interface "Barcode Font Provider 2D";
                    Separator: Text[1];
                    qrcodeString: Text[50];
                    SalesHeader: Record "Sales Header";
                    ExtDocNo: Code[35];
                begin
                    Separator[1] := 9;  //TAB
                    IBarcodeFontProvider := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                    BarcodeSymbology := Enum::"Barcode Symbology 2D"::"QR-Code";
                    ExtDocNo := '';
                    if SalesHeader.get(salesheader."Document Type"::Order, WhseActivityLine."Source No.") then
                        ExtDocNo := SalesHeader."External Document No.";
                    PrintText1 := 'K-SHI Order No.:' + WhseActivityLine."Source No.";
                    PrintText2 := 'Cus. Order No.:' + ExtDocNo;
                    PrintText3 := 'Item No.:' + WhseActivityLine."Item No.";
                    PrintText4 := WhseActivityLine.Description;
                    printtext5 := 'Outbound QTY:' + format(WhseActivityLine."Qty. to Handle");
                    PrintText6 := 'LOC:' + WhseActivityLine."Location Code" + WhseActivityLine."Bin Code";

                    qrcodeString := 'Komax Shanghai Original Part;' + WhseActivityLine."Item No." + ';' + format(WhseActivityLine.Quantity) + ';';
                    EncodedText := IBarcodeFontProvider.EncodeFont(qrcodeString, BarcodeSymbology);
                end;
            }
            trigger OnPreDataItem()
            begin
                PrintDate := Format(WorkDate());
            end;
        }

    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        PrintText1: Text;
        PrintText2: Text;
        PrintText3: Text;
        PrintText4: Text;
        PrintText5: Text;
        PrintText6: Text;
        PrintDate: text;
        EncodedText: Text;
}

