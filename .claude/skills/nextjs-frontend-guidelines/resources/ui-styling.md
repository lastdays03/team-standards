# UI Components & Styling - shadcn/ui + Tailwind CSS 4

## Overview

YGS uses a modern styling stack:
- **shadcn/ui**: Pre-built, accessible components built on Radix UI (copy/paste, not npm dependency)
- **Tailwind CSS 4**: Utility-first CSS framework
- **cn() utility**: Class merging with clsx + tailwind-merge

Components live in `src/components/ui/`. You own the code and can customize freely.

**Available Components in YGS:**
button, input, textarea, card, dialog, select, checkbox, badge, alert, skeleton, image-upload

```bash
# Adding new components
npx shadcn@latest add button
npx shadcn@latest add card
npx shadcn@latest add dialog
```

---

## The cn() Utility (CRITICAL)

### Setup

```typescript
// lib/utils.ts
import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
```

### Usage

```typescript
import { cn } from '@/lib/utils';

// Conditional classes
<div className={cn(
  "flex items-center gap-2 p-4",
  isActive && "bg-primary text-primary-foreground",
  isDisabled && "opacity-50 cursor-not-allowed"
)}>

// Combining variants
<Button className={cn(
  "w-full",
  size === "lg" && "h-12 text-lg"
)}>
```

### Why cn() is Important

```typescript
// WITHOUT cn() - classes may conflict
<div className={`p-4 ${className}`}>  // If className has p-2, both apply

// WITH cn() - later classes override earlier ones
<div className={cn("p-4", className)}>  // p-2 from className wins
```

---

## shadcn/ui Component Variants

### Button

```typescript
import { Button } from '@/components/ui/button';

// Variants
<Button variant="default">Primary</Button>
<Button variant="secondary">Secondary</Button>
<Button variant="destructive">Delete</Button>
<Button variant="outline">Outline</Button>
<Button variant="ghost">Ghost</Button>
<Button variant="link">Link</Button>

// Sizes
<Button size="default">Default</Button>
<Button size="sm">Small</Button>
<Button size="lg">Large</Button>
<Button size="icon"><Icon /></Button>
```

### Card

```typescript
import {
  Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle,
} from '@/components/ui/card';

<Card className="w-[350px]">
  <CardHeader>
    <CardTitle>Card Title</CardTitle>
    <CardDescription>Card description goes here</CardDescription>
  </CardHeader>
  <CardContent>
    <p>Card content</p>
  </CardContent>
  <CardFooter>
    <Button>Action</Button>
  </CardFooter>
</Card>
```

### Input

```typescript
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';

<div className="grid w-full max-w-sm items-center gap-1.5">
  <Label htmlFor="email">Email</Label>
  <Input type="email" id="email" placeholder="Email" />
</div>
```

### Dialog

```typescript
import {
  Dialog, DialogContent, DialogDescription, DialogHeader,
  DialogTitle, DialogTrigger, DialogFooter,
} from '@/components/ui/dialog';

<Dialog>
  <DialogTrigger asChild>
    <Button variant="outline">Open Dialog</Button>
  </DialogTrigger>
  <DialogContent className="sm:max-w-[425px]">
    <DialogHeader>
      <DialogTitle>Dialog Title</DialogTitle>
      <DialogDescription>Description of what this dialog does.</DialogDescription>
    </DialogHeader>
    <div className="py-4">{/* Dialog content */}</div>
    <DialogFooter>
      <Button type="submit">Save changes</Button>
    </DialogFooter>
  </DialogContent>
</Dialog>
```

### Select

```typescript
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from '@/components/ui/select';

<Select>
  <SelectTrigger className="w-[180px]">
    <SelectValue placeholder="Select option" />
  </SelectTrigger>
  <SelectContent>
    <SelectItem value="option1">Option 1</SelectItem>
    <SelectItem value="option2">Option 2</SelectItem>
  </SelectContent>
</Select>
```

---

## Color System

### shadcn/ui Semantic Tokens

```typescript
// Primary colors
<div className="bg-primary text-primary-foreground">Primary</div>

// Secondary colors
<div className="bg-secondary text-secondary-foreground">Secondary</div>

// Muted/subtle
<div className="bg-muted text-muted-foreground">Muted</div>

// Accent
<div className="bg-accent text-accent-foreground">Accent</div>

// Destructive (errors, delete actions)
<div className="bg-destructive text-destructive-foreground">Destructive</div>

// Background and foreground
<div className="bg-background text-foreground">Default</div>

// Border and input
<div className="border border-border">Bordered</div>
<Input className="border-input" />

// Card
<div className="bg-card text-card-foreground">Card</div>
```

### YGS Brand Colors

```typescript
// Primary brand color (Coral/Orange)
className="bg-primary text-white"
className="hover:bg-primary-dark"
className="text-primary"

// Gradients
className="bg-gradient-to-r from-amber-500 to-orange-500"

// Status colors
className="text-red-500"     // Errors, destructive
className="bg-green-50"      // Success
className="text-gray-500"    // Muted

// Status-based styling with cn()
const statusColors: Record<string, string> = {
  draft: "bg-slate-100 text-slate-600",
  active: "bg-green-100 text-green-700",
  suspended: "bg-red-100 text-red-600",
};

<Badge className={cn(statusColors[status] || "bg-gray-100")}>
  {getStatusLabel(status)}
</Badge>
```

---

## Responsive Patterns

```typescript
// Grid
className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4"

// Flex direction
className="flex flex-col md:flex-row gap-4 md:gap-6"

// Text
className="text-xl sm:text-2xl md:text-3xl lg:text-4xl"

// Display
className="hidden md:flex"   // Hidden on mobile
className="md:hidden"        // Mobile only

// Padding
className="px-4 sm:px-6 md:px-12"
className="p-4 md:p-8"
```

---

## Common Layout Patterns

### Responsive Card Grid

```typescript
export function CardGrid({ items }) {
  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
      {items.map((item) => (
        <Card key={item.id}>
          <CardHeader>
            <CardTitle>{item.title}</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-muted-foreground">{item.description}</p>
          </CardContent>
        </Card>
      ))}
    </div>
  );
}
```

### Responsive Sidebar Layout

```typescript
export function Layout({ children }) {
  return (
    <div className="flex min-h-screen">
      <aside className="hidden md:flex w-64 flex-col border-r bg-muted/40">
        {/* Sidebar content */}
      </aside>
      <main className="flex-1 p-4 md:p-8">
        {children}
      </main>
    </div>
  );
}
```

### Loading State with Skeleton

```typescript
import { Skeleton } from '@/components/ui/skeleton';

export function CardSkeleton() {
  return (
    <Card>
      <CardHeader>
        <Skeleton className="h-6 w-[200px]" />
      </CardHeader>
      <CardContent className="space-y-2">
        <Skeleton className="h-4 w-full" />
        <Skeleton className="h-4 w-[80%]" />
      </CardContent>
    </Card>
  );
}
```

---

## YGS Form Patterns

### Pattern 1: Manual State Management (Most Common)

```typescript
'use client';

import { useState, useCallback } from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Loader2 } from 'lucide-react';

interface FormData {
  phone: string;
  name: string;
  gender: string;
  birthYear: string;
}

interface FormErrors {
  phone?: string;
  name?: string;
  gender?: string;
  birthYear?: string;
}

export function SignupForm() {
  const [formData, setFormData] = useState<FormData>({
    phone: '', name: '', gender: '', birthYear: ''
  });
  const [errors, setErrors] = useState<FormErrors>({});
  const [loading, setLoading] = useState(false);

  const validateForm = (): boolean => {
    const newErrors: FormErrors = {};

    if (!/^010-\d{4}-\d{4}$/.test(formData.phone)) {
      newErrors.phone = "올바른 전화번호 형식이 아닙니다.";
    }
    if (formData.name.length < 2) {
      newErrors.name = "이름은 2자 이상이어야 합니다.";
    }
    if (!formData.gender) {
      newErrors.gender = "성별을 선택해주세요.";
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleInputChange = useCallback((field: keyof FormData, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
    if (errors[field]) {
      setErrors(prev => ({ ...prev, [field]: undefined }));
    }
  }, [errors]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!validateForm()) return;

    setLoading(true);
    try {
      await api.post('/signup', formData);
    } catch (err) {
      setErrors({ ...errors, phone: "회원가입에 실패했습니다." });
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div className="space-y-2">
        <Input
          value={formData.phone}
          onChange={e => handleInputChange('phone', e.target.value)}
          placeholder="전화번호"
          className={cn(errors.phone && "border-red-500")}
        />
        {errors.phone && <p className="text-sm text-red-500">{errors.phone}</p>}
      </div>
      <Button type="submit" disabled={loading} className="w-full">
        {loading ? <Loader2 className="animate-spin mr-2 h-4 w-4" /> : null}
        {loading ? "처리 중..." : "가입하기"}
      </Button>
    </form>
  );
}
```

### Pattern 2: Modal Form with Diff-Only Submission

```typescript
'use client';

import { useState, useEffect } from 'react';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { updateMemberBasic } from '@/lib/adminApi';
import type { MemberDetail } from '@/types/admin';

interface EditModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSuccess: (member: MemberDetail) => void;
  member: MemberDetail;
}

export function BasicInfoEditModal({ isOpen, onClose, onSuccess, member }: EditModalProps) {
  const [formData, setFormData] = useState({ name: '', status: '' });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    if (isOpen) {
      setFormData({ name: member.name, status: member.status });
      setError('');
    }
  }, [isOpen, member]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      // Only send changed fields
      const changes: Record<string, string> = {};
      if (formData.name !== member.name) changes.name = formData.name;
      if (formData.status !== member.status) changes.status = formData.status;

      if (Object.keys(changes).length === 0) {
        onClose();
        return;
      }

      const result = await updateMemberBasic(member.id, changes);
      onSuccess(result);
      onClose();
    } catch (err) {
      setError(err instanceof Error ? err.message : '수정에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>기본 정보 수정</DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit} className="space-y-4">
          <Input
            value={formData.name}
            onChange={e => setFormData(prev => ({ ...prev, name: e.target.value }))}
            placeholder="이름"
          />
          {error && <p className="text-sm text-red-500">{error}</p>}
          <DialogFooter>
            <Button type="button" variant="outline" onClick={onClose}>취소</Button>
            <Button type="submit" disabled={loading}>
              {loading ? '저장 중...' : '저장'}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
```

---

## Form Layout Pattern

```typescript
export function Form() {
  return (
    <form className="flex flex-col gap-4 max-w-md mx-auto">
      <div className="space-y-2">
        <Label htmlFor="name">Name</Label>
        <Input id="name" placeholder="Enter your name" />
      </div>
      <div className="space-y-2">
        <Label htmlFor="email">Email</Label>
        <Input id="email" type="email" placeholder="Enter your email" />
      </div>
      <Button type="submit" className="mt-4">Submit</Button>
    </form>
  );
}
```

---

## Dark Mode Support

shadcn/ui has built-in dark mode support through CSS custom properties:

```typescript
// In globals.css
@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
  }
  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
  }
}
```

Components automatically adapt to the current theme.

---

## When to Use What

| Use Case | Approach |
|----------|----------|
| UI elements (buttons, cards, dialogs) | shadcn/ui components |
| Layout (flex, grid, positioning) | Tailwind classes |
| Spacing (padding, margin, gap) | Tailwind classes |
| Customizing shadcn/ui | className prop with cn() |
| One-off styling | Tailwind classes |

## Best Practices

1. **Always use cn()** for conditional or merged class names
2. **Use semantic tokens** (`bg-primary` instead of `bg-blue-500`)
3. **Component-first**: Prefer shadcn/ui components over raw HTML
4. **Customize via className**: Add Tailwind classes to shadcn/ui components
5. **Responsive design**: Use Tailwind responsive prefixes (sm:, md:, lg:)
6. **Keep components in ui/**: All shadcn/ui components in `src/components/ui/`
7. **Don't modify ui/ directly**: Create wrapper components for different defaults
8. **Use proper spacing tokens**: gap-4, p-4, mb-4 for consistency
