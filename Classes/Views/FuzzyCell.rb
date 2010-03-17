# FuzzyCell.rb
# FuzzyWindow
#
# Created by Geoffrey Grosenbach on 3/16/10.
# Copyright 2010 Topfunky Corporation. All rights reserved.


##
# A custom table cell implemented in Ruby.
#
# FuzzyCell#objectValue is the title. Other fields can be set in
# the tableView:willDisplayCell:forTableColumn:row: callback.

class FuzzyCell < NSCell

  attr_accessor :subtitle, :image

  # Vertical padding between the lines of text
  VERTICAL_PADDING = 5.0

  # Horizontal padding between icon and text
  HORIZONTAL_PADDING = 10.0

  def drawInteriorWithFrame(theCellFrame, inView:theControlView)
    anInsetRect = NSInsetRect(theCellFrame, 10, 0)

    # Make attributes for our strings
    aParagraphStyle = NSMutableParagraphStyle.new
    aParagraphStyle.setLineBreakMode(NSLineBreakByTruncatingTail)

    # Title attributes: system font, 14pt, black, truncate tail
    aTitleAttributes = {
      NSForegroundColorAttributeName => NSColor.blackColor,
      NSFontAttributeName => NSFont.systemFontOfSize(14.0),
      NSParagraphStyleAttributeName => aParagraphStyle
    }

    # Subtitle attributes: system font, 12pt, gray, truncate tail
    aSubtitleAttributes = {
      NSForegroundColorAttributeName => NSColor.grayColor,
      NSFontAttributeName => NSFont.systemFontOfSize(12.0),
      NSParagraphStyleAttributeName => aParagraphStyle
    }

    # Make the strings and get their sizes
    # I'm hard coding these strings here.  In a real implementation of a table cell, you'll
    # use the cell's "objectValue" to display real data.

    #    NSString *      aTitle = @"A Realy Realy Realy Really Long Title" # try using this string as the title for testing the truncating tail attribute

    # Make a Title string
    aTitle = self.objectValue
    # get the size of the string for layout
    aTitleSize = aTitle.sizeWithAttributes(aTitleAttributes)

    # Make a Subtitle string
    aSubtitle =  self.subtitle || ""

    # get the size of the string for layout
    aSubtitleSize = aSubtitle.sizeWithAttributes(aSubtitleAttributes)

    # Make the layout boxes for all of our elements - remember that we're in a flipped coordinate system when setting the y-values


    # Icon box: center the icon vertically inside of the inset rect
    anIconBox = drawIconInRect(anInsetRect)

    # Make a box for our text
    # Place it next to the icon with horizontal padding
    # Size it horizontally to fill out the rest of the inset rect
    # Center it vertically inside of the inset rect
    aCombinedHeight = aTitleSize.height + aSubtitleSize.height + VERTICAL_PADDING

    aTextBox = NSMakeRect(anIconBox.origin.x + anIconBox.size.width + HORIZONTAL_PADDING,
                          anInsetRect.origin.y + anInsetRect.size.height * 0.5 - aCombinedHeight * 0.5,
                          anInsetRect.size.width - anIconBox.size.width - HORIZONTAL_PADDING,
                          aCombinedHeight)

    # Now split the text box in half and put the title box in the top half and subtitle box in bottom half
    aTitleBox = NSMakeRect(aTextBox.origin.x,
                           aTextBox.origin.y + aTextBox.size.height * 0.5 - aTitleSize.height,
                           aTextBox.size.width,
                           aTitleSize.height)

    aSubtitleBox = NSMakeRect(aTextBox.origin.x,
                              aTextBox.origin.y + aTextBox.size.height * 0.5,
                              aTextBox.size.width,
                              aSubtitleSize.height)

    if self.highlighted?
      # if the cell is highlighted, draw the text white
      aTitleAttributes[NSForegroundColorAttributeName] = NSColor.whiteColor
      aSubtitleAttributes[NSForegroundColorAttributeName] = NSColor.whiteColor
    else
      # if the cell is not highlighted, draw the title black and the subtile gray
      aTitleAttributes[NSForegroundColorAttributeName] = NSColor.blackColor
      aSubtitleAttributes[NSForegroundColorAttributeName] = NSColor.grayColor
    end

    # Draw the text
    aTitle.drawInRect(aTitleBox, withAttributes:aTitleAttributes)
    aSubtitle.drawInRect(aSubtitleBox, withAttributes:aSubtitleAttributes)
  end

  def drawIconInRect(aRect)
    #anIcon = self.image || NSImage.imageNamed("example")

    # Flip the icon because the entire cell has a flipped coordinate system
    #anIcon.setFlipped(true)

    # get the size of the icon for layout
    #anIconSize = anIcon.size

    iconRect = NSMakeRect(aRect.origin.x,
                          aRect.origin.y + aRect.size.height * 0.5 - 48 * 0.5,
                          48,
                          48)

    # Draw the icon
    #     anIcon.drawInRect(iconRect,
    #                       fromRect:NSZeroRect,
    #                       operation:NSCompositeSourceOver,
    #                       fraction:1.0)

    return iconRect
  end

end