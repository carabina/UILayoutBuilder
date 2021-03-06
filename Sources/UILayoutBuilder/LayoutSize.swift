//
//  LayoutSize.swift
//  UILayoutBuilder
//
//  Created by marty-suzuki on 2020/02/07.
//

#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

public struct LayoutSize {

    private let width: LayoutDimension
    private let height: LayoutDimension

    init(width: LayoutDimension, height: LayoutDimension) {
        self.width = width
        self.height = height
    }
}

extension LayoutSize {

    public var equalTo: Relation {
        .init(width: width.equalTo, height: height.equalTo)
    }
}

extension LayoutSize {
    fileprivate typealias _Builder = UILayoutBuilder.Builder

    public struct Relation {
        fileprivate let width: LayoutDimension.Relation
        fileprivate let height: LayoutDimension.Relation
    }

    public struct Builder {
        private let width: _Builder
        private let height: _Builder

        fileprivate init(width: _Builder, height: _Builder) {
            self.width = width
            self.height = height
        }
    }

    public struct ConstrantGroup {
        public let width: NSLayoutConstraint
        public let height: NSLayoutConstraint
    }
}

extension LayoutSize.ConstrantGroup: ConstrantGroupType {

    public func activate() {
        NSLayoutConstraint.activate([width, height])
    }

    public func deactivate() {
        NSLayoutConstraint.deactivate([width, height])
    }
}

extension LayoutSize.Relation {

    @discardableResult
    public func size(_ layout: LayoutRepresentable) -> LayoutSize.Builder {
        .init(width: width.width(layout), height: height.height(layout))
    }

    @discardableResult
    public func constant(width: CGFloat, height: CGFloat) -> LayoutSize.Builder {
        .init(width: self.width.constant(width), height: self.height.constant(height))
    }
}

extension LayoutSize.Builder {

    @discardableResult
    public func constant(width: CGFloat, height: CGFloat) -> LayoutSize.Builder {
        self.width.constant(width)
        self.height.constant(height)
        return self
    }

    @discardableResult
    public func priority(width: LayoutPriority, height: LayoutPriority) -> LayoutSize.Builder {
        self.width.priority(width)
        self.height.priority(height)
        return self
    }

    @discardableResult
    public func multiplier(width: CGFloat, height: CGFloat) -> LayoutSize.Builder {
        self.width.multiplier(width)
        self.height.multiplier(height)
        return self
    }


    public func asConstraints() -> LayoutSize.ConstrantGroup {
        .init(width: width.asConstraint(),
              height: height.asConstraint())
    }
}
