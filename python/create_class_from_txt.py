
import json
import re

def write_source(enum_name, definitions, descriptions):
    str = """
#if !os(macOS)
import HomeKit
#endif

"""
    
    str = str + f'@objc public enum {enum_name}: Int {{\n'
    for define, desc in zip(definitions, descriptions):
        str = str + f'    case {define["element"]}    // {desc}\n'

    str = str + f'    case unknown\n'

    str = str + f'\n\n'
    str = str + f'    func detail() -> String {{\n'
    str = str + f'        switch self {{\n'
    for define, desc in zip(definitions, descriptions):
        str = str + f'        case .{define["element"]}:\n'
        str = str + f'            return "{desc}"\n'
    
    str = str + f'        case .unknown:\n'
    str = str + f'            return "Unknown"\n'
    str = str + f'        }}\n'
    str = str + f'    }}\n'
    str = str + f'\n'
    str = str + f'\n'
    str = str + f'#if !os(macOS)\n'
    str = str + f'    init(key: String) {{\n'

    str = str + f'        switch key {{\n'
    for define, desc in zip(definitions, descriptions):
        str = str + f'        case {define["original"]}:\n'
        str = str + f'            self = .{define["element"]}\n'
    str = str + f'        default:\n'
    str = str + f'            self = .unknown\n'
    str = str + f'        }}\n'
    str = str + f'    }}\n'
    str = str + f'#endif\n'
    

    str = str + f'}}\n'
    return str

def main():

    entries = [
        {
            'filename': '../HomeMenu/bridge/AccessoryTypeBridge.swift',
            'enum_name': 'AccessoryType',
            'file': 'accessory_category_types.txt',
            'template': r'(let (HMAccessoryCategoryType(.+?)): String$)'
        },
        {
            'filename': '../HomeMenu/bridge/ServiceTypeBridge.swift',
            'enum_name': 'ServiceType',
            'file': 'accessory_service_types.txt',
            'template': r'(let (HMServiceType(.+?)): String$)'
        },
        {
            'filename': '../HomeMenu/bridge/CharacteristicTypeBridge.swift',
            'enum_name': 'CharacteristicType',
            'file': 'characteristic_types.txt',
            'template': r'(let (HMCharacteristicType(.+?)): String$)'
        }
    ]

    for entry in entries:
        with open(entry['file']) as fr:
            lines = fr.readlines()

            definitions = []
            descriptions = []

            for line in lines:
                # case 1 description
                template = r'(.+\.)\n'
                a = re.findall(template, line)
                if len(a) > 0:
                    descriptions.append(a[0])
                    continue

                # case 2 definition
                template = entry['template']
                a = re.findall(template, line)
                if len(a) > 0:
                    element = a[0][2]
                    element = element[0].lower() + element[1:]
                    info = {
                        "original": a[0][1],
                        "element": element
                    }
                    definitions.append(info)
                    continue

            message = f'{len(descriptions)} vs {len(definitions)}'
            assert len(descriptions) == len(definitions), message
            
            str = write_source(entry['enum_name'], definitions, descriptions)
            with open(entry["filename"], 'w') as fw:
                fw.write(str)
main()