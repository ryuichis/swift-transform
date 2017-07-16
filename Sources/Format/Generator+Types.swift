//
//  Generator+Types.swift
//  Format
//
//  Created by Angel Garcia on 14/07/2017.
//

import AST

extension Generator {
    
    open func generate(_ type: Type) -> String {
        switch type {
        case let type as AnyType:
            return generate(type)
        case let type as ArrayType:
            return generate(type)
        case let type as DictionaryType:
            return generate(type)
        case let type as FunctionType:
            return generate(type)
        case let type as ImplicitlyUnwrappedOptionalType:
            return generate(type)
        case let type as MetatypeType:
            return generate(type)
        case let type as OptionalType:
            return generate(type)
        case let type as ProtocolCompositionType:
            return generate(type)
        case let type as SelfType:
            return generate(type)
        case let type as TupleType:
            return generate(type)
        case let type as TypeAnnotation:
            return generate(type)
        case let type as TypeIdentifier:
            return generate(type)
        case let type as TypeInheritanceClause:
            return generate(type)
        default:
            return type.textDescription
        }
    }
    
    open func generate(_ type: AnyType ) -> String {
        return "Any"
    }
    
    open func generate(_ type: ArrayType) -> String {
        return "Array<\(generate(type.elementType))>"
    }
    
    open func generate(_ type: DictionaryType) -> String {
        return "Dictionary<\(generate(type.keyType)), \(generate(type.valueType))>"
    }
    
    open func generate(_ type: FunctionType) -> String {
        let attrsText = type.attributes.isEmpty ? "" : "\(generate(type.attributes)) "
        let argsText = "(\(type.arguments.map(generate).joined(separator: ", ")))"
        let throwsText = generate(type.throwsKind).isEmpty ? "" : " \(generate(type.throwsKind))"
        return "\(attrsText)\(argsText)\(throwsText) -> \(generate(type.returnType))"
    }
    
    open func generate(_ type: FunctionType.Argument) -> String {
        let attr = type.attributes.isEmpty ? "" : "\(generate(type.attributes)) "
        let inoutStr = type.isInOutParameter ? "inout " : ""
        var nameStr = type.externalName.map({ "\($0) " }) ?? ""
        if let localName = type.localName {
            nameStr += "\(localName): "
        }
        let variadicDots = type.isVariadic ? "..." : ""
        return "\(nameStr)\(attr)\(inoutStr)\(generate(type.type))\(variadicDots)"
    }
    
    open func generate(_ type: ImplicitlyUnwrappedOptionalType) -> String {
        return "ImplicitlyUnwrappedOptional<\(generate(type.wrappedType))>"
    }
    
    open func generate(_ type: MetatypeType) -> String {
        switch type.kind {
        case .type:
            return "Type<\(generate(type.referenceType))>"
        case .protocol:
            return "Protocol<\(generate(type.referenceType))>"
        }
    }
    
    open func generate(_ type: OptionalType) -> String {
        return "Optional<\(generate(type.wrappedType))>"
    }
    
    open func generate(_ type: ProtocolCompositionType) -> String {
        return "protocol<\(type.protocolTypes.map(generate).joined(separator: ", "))>"
    }
    
    open func generate(_ type: SelfType) -> String {
        return "Self"
    }
    
    open func generate(_ type: TupleType) -> String {
            return "(\(type.elements.map(generate).joined(separator: ", ")))"
    }
    
    open func generate(_ type: TupleType.Element) -> String {
            let attr = type.attributes.isEmpty ? "" : "\(generate(type.attributes)) "
            let inoutStr = type.isInOutParameter ? "inout " : ""
            var nameStr = ""
            if let name = type.name {
                nameStr = "\(name): "
            }
            return "\(nameStr)\(attr)\(inoutStr)\(generate(type.type))"
    }
    
    open func generate(_ type: TypeAnnotation) -> String {
        let attr = type.attributes.isEmpty ? "" : "\(generate(type.attributes)) "
        let inoutStr = type.isInOutParameter ? "inout " : ""
        return ": \(attr)\(inoutStr)\(generate(type.type))"
    }
    
    open func generate(_ type: TypeIdentifier) -> String {
        return type.names
            .map({ "\($0.name)\($0.genericArgumentClause.map(generate) ?? "")" })
            .joined(separator: ".")
    }
    
    open func generate(_ type: TypeInheritanceClause) -> String {
        var prefixText = ": "
        if type.classRequirement {
            prefixText += "class"
        }
        if type.classRequirement && !type.typeInheritanceList.isEmpty {
            prefixText += ", "
        }
        return "\(prefixText)\(type.typeInheritanceList.map(generate).joined(separator: ", "))"
    }
    
}
