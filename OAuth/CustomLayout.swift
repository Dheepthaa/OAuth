//
//  CustomLayout.swift
//  OAuth
//
//  Created by Dheepthaa Anand on 12/12/17.
//  Copyright © 2017 Dheepthaa Anand. All rights reserved.
//

import UIKit
protocol CustomLayoutDelegate:class
{
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, widthForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
    
} //delegate created to return height and width of photo

class CustomLayout: UICollectionViewLayout
{
    weak var delegate: CustomLayoutDelegate!
    fileprivate var cellPadding: CGFloat = 2
    fileprivate var cache = [UICollectionViewLayoutAttributes]() //meant to contain attributes of each item
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var contentWidth: CGFloat
    {
        guard let collectionView = collectionView else {
            return 0}
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    } //calculates contentwidth based on collectionview width and insets
    
    override var collectionViewContentSize: CGSize
    {
        return CGSize(width: contentWidth, height: contentHeight)
    }//size of collectionview contents based on contentwidth and contentheight
    
    override func prepare()
    {
        self.cache.removeAll()
        guard let collectionView = collectionView else
        {
            return
        }//function proceeds only if none of the items are added
        if collectionView.numberOfItems(inSection: 0) > 0
        {
            var column = -1
            var row = -1
            var yOffset = Array(repeating: Array(repeating: CGFloat(0), count: collectionView.numberOfItems(inSection: 0)), count: collectionView.numberOfItems(inSection: 0))
            var xOffset = Array(repeating: Array(repeating: CGFloat(0), count: collectionView.numberOfItems(inSection: 0)), count: collectionView.numberOfItems(inSection: 0))
            var width1 = Array(repeating: Array(repeating: CGFloat(0), count: collectionView.numberOfItems(inSection: 0)), count: collectionView.numberOfItems(inSection: 0))
            var height1 = Array(repeating: Array(repeating: CGFloat(0), count: collectionView.numberOfItems(inSection: 0)), count: collectionView.numberOfItems(inSection: 0))
            var checked = [Int](repeating:0, count: collectionView.numberOfItems(inSection: 0) )
            xOffset[0][0] = 0
            yOffset[0][0] = 0
            
            var maxh: CGFloat = 0
            var oldmaxh: CGFloat = 0
            var oldyoff: CGFloat = 0
            var rowwid: CGFloat = 0
            var item = 0
            var ct = 0
            var ctrow: CGFloat = 0
            var next = 0
            
            while ct < collectionView.numberOfItems(inSection: 0)
            {
                var iter = item
                if row != -1
                {oldyoff =  yOffset[row][0]}
                row = row + 1
                rowwid = cellPadding
                oldmaxh = maxh
                maxh = 0
                column = -1
                ctrow = 0
                var actualwidth: CGFloat = 0
                repeat
                {
                    let indexPath1 = IndexPath(item: (iter), section: 0)
                    if checked[iter] == 0
                    {
                        let old = rowwid
                        if  delegate.collectionView(collectionView, widthForPhotoAtIndexPath: indexPath1) + cellPadding > (contentWidth-cellPadding)
                        {
                            actualwidth = (contentWidth-2*cellPadding)
                        }
                        else
                        {
                            actualwidth = delegate.collectionView(collectionView, widthForPhotoAtIndexPath: indexPath1) + cellPadding
                        }
                        rowwid = rowwid + actualwidth
                        
                        if rowwid > (contentWidth-cellPadding)
                        {
                            rowwid = old
                            next = iter
                            
                        }
                        else
                        {
                            checked[iter] = 1
                            ctrow = ctrow + 1
                            maxh = max(maxh,delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath1)) //protocol delegate calculates photo height
                        }
                        
                    }
                    iter = (iter + 1)
                    if iter == collectionView.numberOfItems(inSection: 0)
                    {
                        iter = 0
                    }
                    
                } while (iter) != item
                
                item = 0
                
                while item < collectionView.numberOfItems(inSection: 0)
                {
                    if checked[item] == 1
                    {
                        
                        let indexPath = IndexPath(item: item, section: 0)
                        var width2 = delegate.collectionView(collectionView, widthForPhotoAtIndexPath: indexPath) + cellPadding //protocol delegate calculates photo width
                        if width2 > (contentWidth - 2*cellPadding)
                        {
                            width2 = (contentWidth - 2*cellPadding)
                        }
                        let photoWidth =  width2 + ((contentWidth - rowwid)/ctrow)
                        
                        column = column + 1
                        let height = cellPadding * 2 /*up&down*/ + maxh
                        let width =   photoWidth
                        width1[row][column] = width
                        height1[row][column] = height
                        if column != 0
                        {
                            xOffset[row][column] = xOffset[row][column-1] + width1[row][column-1]
                        }
                        
                        if row != 0
                        {
                            yOffset[row][column] = oldyoff + oldmaxh + cellPadding
                        }
                        let frame = CGRect(x: xOffset[row][column], y: yOffset[row][column], width: width, height: height) //width and height including padding
                        let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding) //removes padding
                        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                        attributes.frame = insetFrame
                        cache.append(attributes)
                        contentHeight = max(contentHeight, frame.maxY)
                        checked[item] = 2
                        ct = ct + 1
                    }
                    item = item + 1
                }
                item =  next
            }
        }
    }
       
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in cache
        {
            if attributes.frame.intersects(rect)
            {
                visibleLayoutAttributes.append(attributes) //add item to visible items cache
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    {
        return cache[indexPath.item]
    }
}

